# add_inline_nav.ps1
# Inserts navigation links:
# 1. Immediately after the Chapter Heading (<h1>, <h2>, etc.)
# 2. At the very end of the content (before </body>)

$files = Get-ChildItem -Filter "Chapter_*.html" | Sort-Object Name
$totalFiles = $files.Count

Write-Host "Adding in-page navigation to $totalFiles chapters..."

for ($i = 0; $i -lt $totalFiles; $i++) {
    $file = $files[$i]
    
    # Calculate Links
    $prevIndex = $i - 1
    $nextIndex = $i + 1
    $prevLink = if ($prevIndex -ge 0) { $files[$prevIndex].Name } else { "index.html" }
    $nextLink = if ($nextIndex -lt $totalFiles) { $files[$nextIndex].Name } else { "index.html" }
    
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # 1. Clean up old inline navs to avoid duplicates
    $content = $content -replace '(?s)<div class="inline-nav">.*?</div>', ''
    
    # 2. Define the Navigation HTML Block
    $navHtml = @"
<div class="inline-nav">
    <a href="$prevLink">&larr; Prev</a>
    <a href="index.html">Index</a>
    <a href="$nextLink">Next &rarr;</a>
</div>
"@

    # 3. Insert TOP Navigation (After the first header tag <h1...h6>)
    # This Regex finds the header and appends the Nav HTML after it.
    if ($content -match "(<h[1-6][^>]*>.*?</h[1-6]>)") {
        $content = $content -replace "(<h[1-6][^>]*>.*?</h[1-6]>)", "`$1`n$navHtml"
    } else {
        # Fallback: Insert at start of body if no header found
        $content = $content -replace "(<body[^>]*>)", "`$1`n$navHtml"
    }

    # 4. Insert BOTTOM Navigation (Before closing body tag)
    $content = $content -replace "</body>", "$navHtml`n</body>"

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Host "Navigation inserted at Top and Bottom of all chapters."