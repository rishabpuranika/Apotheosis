# Directory Overview

This directory contains the book "Apotheosis" in HTML format, with each chapter as a separate file. The files are named sequentially (e.g., `Chapter_0001.html`, `Chapter_0002.html`, etc.). A PowerShell script is included to add navigation elements to these HTML files, linking them together for a seamless reading experience.

## Key Files

*   `Chapter_*.html`: These are the individual chapters of the book "Apotheosis".
*   `add-navigation.ps1`: A PowerShell script that injects HTML and CSS into each chapter file to create a navigation bar with "Previous", "Next", and "Index" buttons. This script is essential for navigating the book.
*   `AGENTS.md`: A markdown file containing instructions and guidelines for managing the project, including commands for adding/removing navigation and notes on code style.

## Usage

To prepare the book for reading, you can run the `add-navigation.ps1` script from a PowerShell terminal. This will add navigation controls to the bottom of each chapter.

**Command to add navigation:**
```powershell
./add-navigation.ps1
```

After running the script, you can open any `Chapter_*.html` file in a web browser to start reading. The navigation bar will allow you to move between chapters.
