# Script to remove existing navigation from all chapters

$totalChapters = 4334

Write-Host "Removing old navigation from $totalChapters chapters..."

for ($i = 1; $i -le $totalChapters; $i++) {
    $chapterNum = "{0:D4}" -f $i
    $filePath = "Chapter_$chapterNum.html"
    
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        
        # Remove everything from <style> containing chapter-navigation to </div> before </body>
        $content = $content -replace '(?s)<style>.*?chapter-navigation.*?</style>.*?<div class="chapter-navigation">.*?</div>\s*', ''
        
        # Save the file
        $content | Set-Content $filePath -Encoding UTF8 -NoNewline
        
        if ($i % 100 -eq 0) {
            Write-Host "Processed $i chapters..."
        }
    }
}

Write-Host "Done! Old navigation removed."
