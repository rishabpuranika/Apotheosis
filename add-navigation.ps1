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
    background-color: #2b231d; /* Light mode background */
    color: #e0e0e0; /* Light mode text color */
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
        <button id="darkModeToggle" class="control-button"></button>
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
            darkModeToggle.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="17px" fill="#e3e3e3"><path d="M480-120q-150 0-255-105T120-480q0-150 105-255t255-105q14 0 27.5 1t26.5 3q-41 29-65.5 75.5T444-660q0 90 63 153t153 63q55 0 101-24.5t75-65.5q2 13 3 26.5t1 27.5q0 150-105 255T480-120Zm0-80q88 0 158-48.5T740-375q-20 5-40 8t-40 3q-123 0-209.5-86.5T364-660q0-20 3-40t8-40q-78 32-126.5 102T200-480q0 116 82 198t198 82Zm-10-270Z"/></svg>';
        } else {
            localStorage.removeItem('darkMode');
            darkModeToggle.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="17px" fill="#000000"><path d="M440-800v-120h80v120h-80Zm0 760v-120h80v120h-80Zm360-400v-80h120v80H800Zm-760 0v-80h120v80H40Zm708-252-56-56 70-70 56 56-70 70Zm-496 0 70-70-56-56-70 70 56 56Zm496 496-70-70 56-56 70 70-56 56Zm-496 0 56-56-70-70-56 56 70 70ZM480-280q-101 0-170.5-69.5T240-520q0-101 69.5-170.5T480-760q101 0 170.5 69.5T720-520q0 101-69.5 170.5T480-280Zm0-80q67 0 113.5-46.5T640-520q0-67-46.5-113.5T480-680q-67 0-113.5 46.5T320-520q0 67 46.5 113.5T480-360Zm0-80q-33 0-56.5-23.5T400-520q0-33 23.5-56.5T480-600q33 0 56.5 23.5T560-520q0 33-23.5 56.5T480-440Zm0-40q-13 0-21.5-8.5T450-510q0-13 8.5-21.5T480-540q13 0 21.5 8.5T510-510q0 13-8.5 21.5T480-480Z"/></svg>';
        }
    });

    // Apply saved settings on page load
    if (localStorage.getItem('darkMode') === 'enabled') {
        body.classList.add('dark-mode');
        darkModeToggle.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="17px" fill="#e3e3e3"><path d="M480-120q-150 0-255-105T120-480q0-150 105-255t255-105q14 0 27.5 1t26.5 3q-41 29-65.5 75.5T444-660q0 90 63 153t153 63q55 0 101-24.5t75-65.5q2 13 3 26.5t1 27.5q0 150-105 255T480-120Zm0-80q88 0 158-48.5T740-375q-20 5-40 8t-40 3q-123 0-209.5-86.5T364-660q0-20 3-40t8-40q-78 32-126.5 102T200-480q0 116 82 198t198 82Zm-10-270Z"/></svg>';
    } else {
        darkModeToggle.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="17px" fill="#000000"><path d="M440-800v-120h80v120h-80Zm0 760v-120h80v120h-80Zm360-400v-80h120v80H800Zm-760 0v-80h120v80H40Zm708-252-56-56 70-70 56 56-70 70Zm-496 0 70-70-56-56-70 70 56 56Zm496 496-70-70 56-56 70 70-56 56Zm-496 0 56-56-70-70-56 56 70 70ZM480-280q-101 0-170.5-69.5T240-520q0-101 69.5-170.5T480-760q101 0 170.5 69.5T720-520q0 101-69.5 170.5T480-280Zm0-80q67 0 113.5-46.5T640-520q0-67-46.5-113.5T480-680q-67 0-113.5 46.5T320-520q0 67 46.5 113.5T480-360Zm0-80q-33 0-56.5-23.5T400-520q0-33 23.5-56.5T480-600q33 0 56.5 23.5T560-520q0 33-23.5 56.5T480-440Zm0-40q-13 0-21.5-8.5T450-510q0-13 8.5-21.5T480-540q13 0 21.5 8.5T510-510q0 13-8.5 21.5T480-480Z"/></svg>';
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
