# fix_duplicates.ps1
# This script performs a DEEP CLEAN of all navigation controls (Simple, Smart, and Advanced)
# and then installs a single, clean "Settings Gear" instance.

$files = Get-ChildItem -Filter "Chapter_*.html" | Sort-Object Name
$totalFiles = $files.Count

Write-Host "Deep cleaning and updating $totalFiles chapters..."

for ($i = 0; $i -lt $totalFiles; $i++) {
    $file = $files[$i]
    
    # Calculate Links
    $prevIndex = $i - 1
    $nextIndex = $i + 1
    $prevLink = if ($prevIndex -ge 0) { $files[$prevIndex].Name } else { "index.html" }
    $nextLink = if ($nextIndex -lt $totalFiles) { $files[$nextIndex].Name } else { "index.html" }
    
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # --- PHASE 1: AGGRESSIVE CLEANUP ---
    
    # 1. Remove Simple/Smart Nav Bars (Single line divs)
    $content = $content -replace '(?s)<div[^>]*class="navigation".*?</div>', ''
    $content = $content -replace '(?s)<div[^>]*id="sticky-nav".*?</div>', ''
    
    # 2. Remove Floating Gear Icon (Simple div)
    $content = $content -replace '(?s)<div[^>]*class="nav-trigger".*?</div>', ''
    
    # 3. Remove "broken" Nav Menus (The specific cause of your duplication)
    # This regex looks for the start of the menu, looks for unique text inside it (Theme/Dark Mode), and eats until the end.
    $content = $content -replace '(?s)<div class="nav-menu" id="navMenu">.*?Dark / Light.*?</button>\s*</div>\s*</div>', ''
    
    # 4. Remove any "dangling" parts of the menu if the above regex missed slightly
    $content = $content -replace '(?s).*?Dark / Light.*?</button>\s*</div>\s*</div>', ''
    
    # 5. Remove Scripts
    $content = $content -replace '(?s)<script>.*?function toggleMenu.*?/script>', ''
    $content = $content -replace '(?s)<script>.*?function toggleNav.*?/script>', ''
    $content = $content -replace '(?s)<script>.*?adjustFont.*?/script>', ''

    # --- PHASE 2: INSERT CLEAN VERSION ---
    
    $cleanMenuHtml = @"
    <div class="nav-trigger" onclick="toggleMenu()">&#9881;</div> 

    <div class="nav-menu" id="navMenu">
        
        <a href="$prevLink">Previous Chapter</a>
        <a href="index.html">Table of Contents</a>
        <a href="$nextLink">Next Chapter</a>

        <div class="settings-section">
            <span class="settings-label">Font Size</span>
            <button class="font-btn" onclick="adjustFont(-1)">A-</button>
            <button class="font-btn" onclick="adjustFont(1)">A+</button>
        </div>

        <div class="settings-section" style="border-bottom: none;">
            <span class="settings-label">Theme</span>
            <button class="font-btn" style="width: 100%;" onclick="toggleDarkMode()">&#127769; Dark / Light</button>
        </div>
    </div>

    <script>
    document.addEventListener("DOMContentLoaded", function() {
        if (localStorage.getItem("darkMode") === "enabled") { document.body.classList.add("dark-mode"); }
        var savedSize = localStorage.getItem("fontSize");
        if (savedSize) { document.body.style.fontSize = savedSize + "px"; }
    });
    function toggleMenu() {
        var menu = document.getElementById("navMenu");
        menu.style.display = (menu.style.display === "block") ? "none" : "block";
    }
    function adjustFont(delta) {
        var style = window.getComputedStyle(document.body, null).getPropertyValue('font-size');
        var newSize = parseFloat(style) + delta;
        if (newSize >= 12 && newSize <= 40) {
            document.body.style.fontSize = newSize + "px";
            localStorage.setItem("fontSize", newSize);
        }
    }
    function toggleDarkMode() {
        var body = document.body;
        body.classList.toggle("dark-mode");
        localStorage.setItem("darkMode", body.classList.contains("dark-mode") ? "enabled" : "disabled");
    }
    </script>
"@

    # Insert immediately after <body>, ensuring no extra newlines pile up
    if ($content -match "<body[^>]*>") {
        $content = $content -replace "(<body[^>]*>)", "`$1`n$cleanMenuHtml"
    } else {
        $content = $cleanMenuHtml + $content
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Host "Cleanup and Update Finished! Duplicates should be gone."