# Script to add Previous/Next navigation buttons to all chapter files

$totalChapters = 4334

Write-Host "Adding navigation buttons to $totalChapters chapters..."

for ($i = 1; $i -le $totalChapters; $i++) {
    $chapterNum = "{0:D4}" -f $i
    $filePath = "Chapter_$chapterNum.html"
    
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        
        # Check if navigation already exists
        if ($content -match "chapter-navigation") {
            continue
        }
        
        # Prepare navigation HTML
        $prevChapter = if ($i -gt 1) { "Chapter_{0:D4}.html" -f ($i - 1) } else { "" }
        $nextChapter = if ($i -lt $totalChapters) { "Chapter_{0:D4}.html" -f ($i + 1) } else { "" }
        
        $navHTML = @"
<style>
.chapter-navigation {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background: linear-gradient(to right, #2c3e50, #3498db);
    padding: 8px 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 -2px 10px rgba(0,0,0,0.3);
    z-index: 1000;
}
.nav-button, .control-button {
    padding: 8px 12px;
    background-color: white;
    color: #2c3e50;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
    transition: all 0.3s;
    border: 2px solid white;
    font-size: 14px;
    cursor: pointer;
}
.nav-button:hover, .control-button:hover {
    background-color: #3498db;
    color: white;
    transform: scale(1.05);
}
.nav-button:disabled {
    opacity: 0.3;
    cursor: not-allowed;
}
.chapter-info {
    color: white;
    font-weight: bold;
    font-size: 14px;
}
.index-button {
    padding: 8px 16px;
    background-color: #e74c3c;
    color: white;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
    transition: all 0.3s;
    font-size: 14px;
}
.index-button:hover {
    background-color: #c0392b;
    transform: scale(1.05);
}
body {
    padding-bottom: 50px;
    font-size: 16px; /* Default font size */
}
.dark-mode {
    background-color: #121212;
    color: #e0e0e0;
}
.dark-mode .chapter-navigation {
    background: linear-gradient(to right, #1a2833, #236fa1);
}
.dark-mode .nav-button, .dark-mode .control-button {
    background-color: #333;
    color: #e0e0e0;
    border-color: #555;
}
.dark-mode .nav-button:hover, .dark-mode .control-button:hover {
    background-color: #236fa1;
    color: white;
}
.dark-mode h2 {
    color: #e0e0e0;
}
.font-size-controls button.active {
    background-color: #3498db;
    color: white;
}
.dark-mode .font-size-controls button.active {
    background-color: #236fa1;
}
.nav-controls {
    display: flex;
    align-items: center;
    gap: 10px;
}
</style>
<div class="chapter-navigation">
    <div class="nav-controls">
"@
        
        if ($i -gt 1) {
            $navHTML += "`n        <a href=`"$prevChapter`" class=`"nav-button`">Previous</a>"
        } else {
            $navHTML += "`n        <span class=`"nav-button`" style=`"opacity: 0.3; cursor: not-allowed;`">Previous</span>"
        }
        
        $navHTML += "`n        <a href=`"index.html`" class=`"index-button`">Index</a>"
        
        if ($i -lt $totalChapters) {
            $navHTML += "`n        <a href=`"$nextChapter`" class=`"nav-button`">Next</a>"
        } else {
            $navHTML += "`n        <span class=`"nav-button`" style=`"opacity: 0.3; cursor: not-allowed;`">Next</span>"
        }
        $navHTML += @"
    </div>
    <span class=`"chapter-info`">Chapter $i of $totalChapters</span>
    <div class="nav-controls font-size-controls">
        <button id="darkModeToggle" class="control-button">🌙</button>
        <button class="control-button" onclick="changeFontSize('small')">A-</button>
        <button class="control-button" onclick="changeFontSize('medium')">A</button>
        <button class="control-button" onclick="changeFontSize('large')">A+</button>
    </div>
</div>
"@
        $script = @"
<script>
    const darkModeToggle = document.getElementById('darkModeToggle');
    const body = document.body;
    const fontSizeButtons = document.querySelectorAll('.font-size-controls button');

    function changeFontSize(size) {
        let fontSize = '16px';
        if (size === 'small') fontSize = '14px';
        if (size === 'large') fontSize = '18px';
        body.style.fontSize = fontSize;
        localStorage.setItem('fontSize', size);
        updateActiveFontSizeButton(size);
    }

    function updateActiveFontSizeButton(size) {
        fontSizeButtons.forEach(button => {
            button.classList.remove('active');
            if(button.textContent.includes('A-') && size === 'small') button.classList.add('active');
            if(button.textContent === 'A' && size === 'medium') button.classList.add('active');
            if(button.textContent.includes('A+') && size === 'large') button.classList.add('active');
        });
    }

    darkModeToggle.addEventListener('click', () => {
        body.classList.toggle('dark-mode');
        if (body.classList.contains('dark-mode')) {
            localStorage.setItem('darkMode', 'enabled');
            darkModeToggle.textContent = '☀️';
        } else {
            localStorage.removeItem('darkMode');
            darkModeToggle.textContent = '🌙';
        }
    });

    // Apply saved settings on page load
    if (localStorage.getItem('darkMode') === 'enabled') {
        body.classList.add('dark-mode');
        darkModeToggle.textContent = '☀️';
    }

    const savedSize = localStorage.getItem('fontSize') || 'medium';
    changeFontSize(savedSize);

</script>
"@
        
        # Insert navigation before </body>
        $content = $content -replace "</body>", "$navHTML`n$script`n</body>"
        
        # Save the file
        $content | Set-Content $filePath -Encoding UTF8 -NoNewline
        
        if ($i % 100 -eq 0) {
            Write-Host "Processed $i chapters..."
        }
    }
}

Write-Host "Done! All chapters now have navigation buttons."
