# How to run this script:
# powershell -NoProfile -ExecutionPolicy Bypass -File scripts\save_reports.ps1 -Project conv_block1 -ReportName conv_block1_csynth.rpt

param(
    [Parameter(Mandatory=$true)]
    [string]$Project,

    [Parameter(Mandatory=$true)]
    [string]$ReportName
)

# Project root
$root = Split-Path -Parent $PSScriptRoot

# Source report path
$source = Join-Path $root "$Project\solution1\syn\report\$ReportName"

# Destination directory
$reportDir = Join-Path $root "reports"

# Check source file
if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    Write-Error "Report not found: $source"
    exit 1
}

# Create reports directory
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

# Generate timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmm"

# Generate output filename
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($ReportName)
$extension = [System.IO.Path]::GetExtension($ReportName)
$newName = "${baseName}_${timestamp}${extension}"

# Avoid overwriting reports saved in the same minute
$index = 1
while (Test-Path -LiteralPath (Join-Path $reportDir $newName)) {
    $newName = "${baseName}_${timestamp}_$('{0:D2}' -f $index)${extension}"
    $index++
}

# Copy report
$destination = Join-Path $reportDir $newName
Copy-Item -LiteralPath $source -Destination $destination

Write-Host "SAVED: $newName"
