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
.nav-button {
    padding: 8px 16px;
    background-color: white;
    color: #2c3e50;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
    transition: all 0.3s;
    border: 2px solid white;
    font-size: 14px;
}
.nav-button:hover {
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
}
</style>
<div class="chapter-navigation">
"@
        
        if ($i -gt 1) {
            $navHTML += "`n    <a href=`"$prevChapter`" class=`"nav-button`">Previous</a>"
        } else {
            $navHTML += "`n    <span class=`"nav-button`" style=`"opacity: 0.3; cursor: not-allowed;`">Previous</span>"
        }
        
        $navHTML += "`n    <a href=`"index.html`" class=`"index-button`">Index</a>"
        $navHTML += "`n    <span class=`"chapter-info`">Chapter $i of $totalChapters</span>"
        
        if ($i -lt $totalChapters) {
            $navHTML += "`n    <a href=`"$nextChapter`" class=`"nav-button`">Next</a>"
        } else {
            $navHTML += "`n    <span class=`"nav-button`" style=`"opacity: 0.3; cursor: not-allowed;`">Next</span>"
        }
        
        $navHTML += "`n</div>"
        
        # Insert navigation before </body>
        $content = $content -replace "</body>", "$navHTML`n</body>"
        
        # Save the file
        $content | Set-Content $filePath -Encoding UTF8 -NoNewline
        
        if ($i % 100 -eq 0) {
            Write-Host "Processed $i chapters..."
        }
    }
}

Write-Host "Done! All chapters now have navigation buttons."
