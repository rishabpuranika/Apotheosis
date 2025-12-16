# remove_header_controls.ps1

$files = Get-ChildItem -Filter "Chapter_*.html"
$count = 0

Write-Host "Scanning files to remove specific header controls..."

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Regex Pattern Breakdown:
    # 1. Matches <span class="chapter-info">Chapter (any number) of (any number)</span>
    # 2. Matches whitespace
    # 3. Matches <div class="nav-controls font-size-controls">
    # 4. Matches the buttons inside non-greedily (.*?)
    # 5. Matches the closing divs and the start of the script tag
    $pattern = '(?s)<span class="chapter-info">Chapter \d+ of \d+</span>\s*<div class="nav-controls font-size-controls">.*?</div>\s*</div>\s*<script>'
    
    if ($content -match $pattern) {
        # Replace the matched block with just <script>
        $newContent = $content -replace $pattern, '<script>'
        
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        $count++
    }
}

Write-Host "Done. Cleaned up controls in $count files."