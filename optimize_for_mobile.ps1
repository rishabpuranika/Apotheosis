# optimize_for_mobile.ps1
# This script adds the mobile viewport meta tag to all Chapter HTML files.

$files = Get-ChildItem -Filter "Chapter_*.html"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Encoding UTF8
    
    # Check if viewport meta tag already exists to avoid duplicates
    if ($content -notmatch '<meta name="viewport"') {
        # Insert the meta tag immediately after the opening <head> tag
        $newContent = $content -replace '<head>', "<head>`n<meta name=""viewport"" content=""width=device-width, initial-scale=1.0""/>"
        
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        Write-Host "Updated $($file.Name)"
    } else {
        Write-Host "Skipped $($file.Name) (already optimized)"
    }
}

Write-Host "Mobile optimization complete."