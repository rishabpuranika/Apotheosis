
param (
    [string]$nameToReplace,
    [string]$replacementName
)

if ([string]::IsNullOrEmpty($nameToReplace)) {
    $nameToReplace = Read-Host "Enter the name to replace"
}

if ([string]::IsNullOrEmpty($replacementName)) {
    $replacementName = Read-Host "Enter the replacement name"
}

if ([string]::IsNullOrEmpty($nameToReplace) -or [string]::IsNullOrEmpty($replacementName)) {
    Write-Host "Both the name to replace and the replacement name must be provided."
    return
}

$files = Get-ChildItem -Path . -Filter "Chapter_*.html" -Recurse
$files += Get-ChildItem -Path . -Filter "toc.ncx" -Recurse

foreach ($file in $files) {
    (Get-Content $file.PSPath) |
    ForEach-Object { $_ -replace $nameToReplace, $replacementName } |
    Set-Content $file.PSPath
}

Write-Host "Replacement complete. Replaced '$nameToReplace' with '$replacementName' in all chapter files and the table of contents."
