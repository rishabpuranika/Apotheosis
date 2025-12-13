# AGENTS.md - Apotheosis EPUB Project

## Build/Lint/Test Commands

**Navigation Management:**
- Add navigation: `.\add-navigation.ps1` (adds Previous/Next buttons to all chapters)
- Remove navigation: `.\remove-navigation.ps1` (removes existing navigation)

**Validation:**
- EPUB validation: Use epubcheck or similar tool on the directory
- HTML validation: `tidy -q Chapter_0001.html` (install tidy first)

## Code Style Guidelines

**HTML:**
- Use XHTML 1.1 DOCTYPE with proper XML declaration
- UTF-8 encoding required
- Self-closing tags for empty elements
- Consistent indentation with spaces
- Chapter files named `Chapter_XXXX.html` (zero-padded 4-digit numbers)

**CSS:**
- Modern CSS3 features: flexbox, gradients, transitions, transforms
- Class naming: kebab-case (e.g., `chapter-navigation`, `nav-button`)
- Use semantic class names over generic ones
- Fixed positioning for navigation elements

**PowerShell:**
- UTF8 encoding for file operations
- Use `Get-Content -Raw` for reading entire files
- Progress reporting every 100 iterations for long operations
- Error handling with `Test-Path` checks
- String formatting with `-f` operator for zero-padding

**File Organization:**
- EPUB structure: content.opf, toc.ncx, META-INF/container.xml
- Stylesheets: stylesheet.css, page_styles.css
- Assets: cover.jpg, mimetype file

**Best Practices:**
- Always test navigation scripts on a backup copy first
- Maintain consistent chapter numbering (1-4334)
- Use relative paths for internal links
- Validate EPUB structure before distribution