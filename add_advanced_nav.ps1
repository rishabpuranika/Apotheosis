# add_advanced_nav.ps1
# Adds Gear Icon with: Previous/Next links, Font Size +/-, and Dark Mode Toggle.

$files = Get-ChildItem -Filter "Chapter_*.html" | Sort-Object Name
$totalFiles = $files.Count

Write-Host "Upgrading navigation for $totalFiles chapters..."

for ($i = 0; $i -lt $totalFiles; $i++) {
    $file = $files[$i]
    
    # Calculate Previous and Next links
    $prevIndex = $i - 1
    $nextIndex = $i + 1
    $prevLink = if ($prevIndex -ge 0) { $files[$prevIndex].Name } else { "index.html" }
    $nextLink = if ($nextIndex -lt $totalFiles) { $files[$nextIndex].Name } else { "index.html" }
    
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # 1. REMOVE OLD NAV & SCRIPTS (Cleanup)
    $content = $content -replace '(?s)<div[^>]*class="navigation".*?</div>', ''
    $content = $content -replace '(?s)<div[^>]*class="nav-trigger".*?</div>', ''
    $content = $content -replace '(?s)<div[^>]*class="nav-menu".*?</div>', ''
    $content = $content -replace '(?s)<div[^>]*id="sticky-nav".*?</div>', ''
    $content = $content -replace '(?s)<script>.*?function toggle.*?/script>', ''

    # 2. DEFINE NEW SUPER MENU HTML
    $superMenuHtml = @"
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
    // 1. Initialize Settings on Load
    document.addEventListener("DOMContentLoaded", function() {
        // Load Dark Mode
        if (localStorage.getItem("darkMode") === "enabled") {
            document.body.classList.add("dark-mode");
        }
        
        // Load Font Size
        var savedSize = localStorage.getItem("fontSize");
        if (savedSize) {
            document.body.style.fontSize = savedSize + "px";
        }
    });

    // 2. Menu Toggle
    function toggleMenu() {
        var menu = document.getElementById("navMenu");
        menu.style.display = (menu.style.display === "block") ? "none" : "block";
    }

    // 3. Font Size Adjustment
    function adjustFont(delta) {
        var style = window.getComputedStyle(document.body, null).getPropertyValue('font-size');
        var currentSize = parseFloat(style);
        var newSize = currentSize + delta;
        
        // Limit min/max size (e.g., 12px to 40px)
        if (newSize >= 12 && newSize <= 40) {
            document.body.style.fontSize = newSize + "px";
            localStorage.setItem("fontSize", newSize);
        }
    }

    // 4. Dark Mode Toggle
    function toggleDarkMode() {
        var body = document.body;
        body.classList.toggle("dark-mode");
        
        if (body.classList.contains("dark-mode")) {
            localStorage.setItem("darkMode", "enabled");
        } else {
            localStorage.setItem("darkMode", "disabled");
        }
    }
    </script>
"@

    # 3. INJECT INTO BODY
    if ($content -match "<body[^>]*>") {
        $content = $content -replace "(<body[^>]*>)", "`$1`n$superMenuHtml"
    } else {
        $content = $superMenuHtml + $content
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Host "Upgrade Complete! Check your new settings menu."