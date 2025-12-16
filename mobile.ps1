# Script to add Previous/Next navigation buttons to all chapter files
# Optimized for both mobile and desktop reading

$totalChapters = 4334

Write-Host "Adding navigation buttons to $totalChapters chapters..."

for ($i = 1; $i -le $totalChapters; $i++) {
    $chapterNum = "{0:D4}" -f $i
    $filePath = "Chapter_$chapterNum.html"
    
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        
        # Remove old navigation if it exists
        if ($content -match "chapter-navigation") {
            Write-Host "Removing old navigation from Chapter $i..."
            # Find and remove the old style block (from first .chapter-navigation to end of </style>)
            $content = $content -replace '(?s)<style>[^<]*?\.chapter-navigation.*?</style>\s*', ''
            # Remove the navigation div
            $content = $content -replace '(?s)<div class="chapter-navigation">.*?</div>\s*', ''
            # Remove the old script block (look for the entire script with darkModeToggle)
            $content = $content -replace '(?s)<script>\s*const darkModeToggle.*?</script>\s*', ''
        }
        
        # Ensure viewport meta tag exists
        if ($content -notmatch 'viewport') {
            $content = $content -replace '<meta name="generator"', '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0"/><meta name="generator"'
        }
        
        # Prepare navigation HTML
        $prevChapter = if ($i -gt 1) { "Chapter_{0:D4}.html" -f ($i - 1) } else { "" }
        $nextChapter = if ($i -lt $totalChapters) { "Chapter_{0:D4}.html" -f ($i + 1) } else { "" }
        
        $navHTML = @"
<style>
/* Base styles */
* {
    box-sizing: border-box;
}

body {
    padding-bottom: 80px;
    padding-left: 15px;
    padding-right: 15px;
    font-size: 16px;
    line-height: 1.6;
    margin: 0;
}

/* Navigation container */
.chapter-navigation {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background: linear-gradient(to right, #2c3e50, #232B3E);
    padding: 10px 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 -2px 10px rgba(0,0,0,0.3);
    z-index: 1000;
    flex-wrap: wrap;
    gap: 10px;
}

/* Button controls container */
.nav-controls {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

/* All buttons base style */
.nav-button, .control-button, .index-button {
    padding: 10px 16px;
    background-color: white;
    color: #2c3e50;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
    transition: all 0.3s;
    border: 2px solid white;
    font-size: 14px;
    cursor: pointer;
    display: inline-block;
    text-align: center;
    min-width: 44px;
    min-height: 44px;
    line-height: 1.2;
}

.nav-button:hover, .control-button:hover {
    background-color: #232B3E;
    color: white;
    transform: scale(1.05);
}

.nav-button:disabled, .nav-button.disabled {
    opacity: 0.3;
    cursor: not-allowed;
}

.index-button {
    background-color: #e74c3c;
    color: white;
    border-color: #e74c3c;
}

.index-button:hover {
    background-color: #c0392b;
    transform: scale(1.05);
}

/* Chapter info */
.chapter-info {
    color: white;
    font-weight: bold;
    font-size: 14px;
    white-space: nowrap;
}

/* Dark mode styles - KEEP ORIGINAL */
.dark-mode {
    background-color: #121212;
    color: #e0e0e0;
}

.dark-mode .chapter-navigation {
    background: linear-gradient(to right, #1a2833, #236fa1);
}

.dark-mode .nav-button, 
.dark-mode .control-button {
    background-color: #333;
    color: #e0e0e0;
    border-color: #555;
}

.dark-mode .nav-button:hover, 
.dark-mode .control-button:hover {
    background-color: #236fa1;
    color: white;
}

.dark-mode h2 {
    color: #e0e0e0;
}

/* Font size controls */
.font-size-controls button.active {
    background-color: #232B3E;
    color: white;
}

.dark-mode .font-size-controls button.active {
    background-color: #236fa1;
}

/* Mobile optimizations */
@media (max-width: 768px) {
    body {
        padding-bottom: 100px;
        padding-left: 10px;
        padding-right: 10px;
        font-size: 18px;
    }
    
    .chapter-navigation {
        flex-direction: column;
        align-items: stretch;
        padding: 12px 10px;
        gap: 8px;
    }
    
    .nav-controls {
        width: 100%;
        justify-content: space-between;
    }
    
    .chapter-info {
        order: -1;
        text-align: center;
        padding: 8px 0;
        font-size: 16px;
        width: 100%;
    }
    
    .nav-button, .control-button, .index-button {
        padding: 12px 14px;
        font-size: 15px;
        flex: 1;
    }
    
    .font-size-controls {
        width: 100%;
        justify-content: center;
    }
    
    h2 {
        font-size: 1.5em;
        margin: 20px 0;
    }
}

/* Tablet optimizations */
@media (min-width: 769px) and (max-width: 1024px) {
    body {
        padding-bottom: 90px;
        font-size: 17px;
    }
    
    .chapter-navigation {
        padding: 12px 20px;
    }
}

/* Desktop large screens */
@media (min-width: 1440px) {
    body {
        max-width: 1200px;
        margin: 0 auto;
    }
}

/* Print styles */
@media print {
    .chapter-navigation {
        display: none;
    }
    
    body {
        padding-bottom: 0;
    }
}
</style>
<div class="chapter-navigation">
    <div class="nav-controls">
"@
        
        if ($i -gt 1) {
            $navHTML += "`n        <a href=`"$prevChapter`" class=`"nav-button`">Previous</a>"
        } else {
            $navHTML += "`n        <span class=`"nav-button disabled`">Previous</span>"
        }
        
        $navHTML += "`n        <a href=`"index.html`" class=`"index-button`">Index</a>"
        
        if ($i -lt $totalChapters) {
            $navHTML += "`n        <a href=`"$nextChapter`" class=`"nav-button`">Next</a>"
        } else {
            $navHTML += "`n        <span class=`"nav-button disabled`">Next</span>"
        }
        
        $navHTML += @"
    </div>
    <span class="chapter-info">Chapter $i of $totalChapters</span>
    <div class="nav-controls font-size-controls">
        <button id="darkModeToggle" class="control-button"></button>
        <button class="control-button" onclick="changeFontSize('small')">A-</button>
        <button class="control-button" onclick="changeFontSize('medium')">A</button>
        <button class="control-button" onclick="changeFontSize('large')">A+</button>
    </div>
</div>
"@
        
        # ORIGINAL DARK MODE SCRIPT - NO CHANGES
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
            darkModeToggle.innerHTML = '🌙';
        } else {
            localStorage.removeItem('darkMode');
            darkModeToggle.innerHTML = '☀️';
        }
    });

    // Apply saved settings on page load
    if (localStorage.getItem('darkMode') === 'enabled') {
        body.classList.add('dark-mode');
        darkModeToggle.innerHTML = '🌙';
    } else {
        darkModeToggle.innerHTML = '☀️';
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

Write-Host "Done! All chapters now have responsive navigation for mobile and desktop."