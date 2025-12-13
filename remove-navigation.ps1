# Script to remove navigation from all chapter files

$totalChapters = 4334

Write-Host "Removing navigation from $totalChapters chapters..."

for ($i = 1; $i -le $totalChapters; $i++) {
    $chapterNum = "{0:D4}" -f $i
    $filePath = "Chapter_$chapterNum.html"
    
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        
        # Remove navigation HTML and styles
        $content = $content -replace '(?s)<style>\s*\.chapter-navigation.*?</style>', ''
        $content = $content -replace '(?s)<div class="chapter-navigation">.*?</div>', ''
        $content = $content -replace '</body>', "</body>`n"
        
        # Save the file
        $content | Set-Content $filePath -Encoding UTF8 -NoNewline
        
        if ($i % 100 -eq 0) {
            Write-Host "Processed $i chapters..."
        }
    }
}

Write-Host "Done! All chapters have had navigation removed."
