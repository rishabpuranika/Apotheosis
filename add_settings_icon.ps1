# add_settings_icon.ps1

$files = Get-ChildItem -Filter "Chapter_*.html" | Sort-Object Name
$totalFiles = $files.Count

Write-Host "Updating $totalFiles chapters with Settings Icon..."

for ($i = 0; $i -lt $totalFiles; $i++) {
    $file = $files[$i]
    
    # Calculate Previous and Next
    $prevIndex = $i - 1
    $nextIndex = $i + 1
    
    $prevLink = if ($prevIndex -ge 0) { $files[$prevIndex].Name } else { "index.html" }
    $nextLink = if ($nextIndex -lt $totalFiles) { $files[$nextIndex].Name } else { "index.html" }
    
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # 1. Clean up old navigation bars (Regex to find div with class navigation)
    $content = $content -replace '(?s)<div[^>]*class="navigation".*?</div>', ''
    $content = $content -replace '(?s)<div[^>]*id="sticky-nav".*?</div>', ''
    
    # 2. Define the new "Settings Icon" HTML
    $settingsHtml = @"
    <div class="nav-trigger" onclick="toggleMenu()">&#9881;</div> 
    
    <div class="nav-menu" id="navMenu">
        <div style="font-weight: bold; margin-bottom: 5px; color: #666;">Navigation</div>
        <a href="$prevLink">Previous Chapter</a>
        <a href="index.html">Table of Contents</a>
        <a href="$nextLink">Next Chapter</a>
    </div>

    <script>
    function toggleMenu() {
        var menu = document.getElementById("navMenu");
        if (menu.style.display === "block") {
            menu.style.display = "none";
        } else {
            menu.style.display = "block";
        }
    }
    </script>
"@

    # 3. Inject into body
    if ($content -match "<body[^>]*>") {
        $content = $content -replace "(<body[^>]*>)", "`$1`n$settingsHtml"
    } else {
        $content = $settingsHtml + $content
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Host "Done! You now have a Settings icon in every chapter."