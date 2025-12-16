# add_smart_nav.ps1
# 1. Removes old navbars
# 2. Adds a new minimizable navbar with Hamburger menu
# 3. Adds necessary Javascript

$files = Get-ChildItem -Filter "Chapter_*.html" | Sort-Object Name
$totalFiles = $files.Count

Write-Host "Found $totalFiles chapters. Updating navigation..."

for ($i = 0; $i -lt $totalFiles; $i++) {
    $file = $files[$i]
    
    # Calculate Previous and Next filenames
    $prevIndex = $i - 1
    $nextIndex = $i + 1
    
    $prevLink = if ($prevIndex -ge 0) { $files[$prevIndex].Name } else { "index.html" }
    $nextLink = if ($nextIndex -lt $totalFiles) { $files[$nextIndex].Name } else { "index.html" }
    
    # Read content
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # --- 1. REMOVE OLD NAV ---
    # Removes generic div with links to Previous/Next if found
    $content = $content -replace '(?s)<div[^>]*class="navigation".*?</div>', ''
    $content = $content -replace '(?s)<div style="position: fixed.*?</div>', ''
    
    # --- 2. CREATE NEW SMART NAV HTML ---
    $navHtml = @"
<div class="navigation" id="sticky-nav">
    <div class="nav-container">
        <button class="nav-toggle" onclick="toggleNav()">&#9776; Menu</button>
        <div class="nav-links" id="nav-links">
            <a href="$prevLink">Previous</a> | 
            <a href="index.html">Table of Contents</a> | 
            <a href="$nextLink">Next</a>
        </div>
    </div>
</div>
<script>
function toggleNav() {
    var links = document.getElementById("nav-links");
    if (links.style.display === "block") {
        links.style.display = "none";
    } else {
        links.style.display = "block";
    }
}
</script>
"@

    # --- 3. INSERT NEW NAV ---
    # Insert immediately after <body> tag
    if ($content -match "<body[^>]*>") {
        $content = $content -replace "(<body[^>]*>)", "`$1`n$navHtml"
    } else {
        # Fallback if no body tag found standardly
        $content = $navHtml + $content
    }

    # Save content
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Host "Success! Smart navigation added to all chapters."