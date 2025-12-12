# Deploy Climate Scheduler Card to Production
# Target: homeassistant.local/www/community/climate-scheduler-card

$ErrorActionPreference = "Stop"

$SOURCE = ".\dist"
$TARGET = "\\homeassistant.local\config\www\community\climate-scheduler-card"

Write-Host "=== Deploying Climate Scheduler Card to Production ===" -ForegroundColor Cyan
Write-Host "Source: $SOURCE" -ForegroundColor Gray
Write-Host "Target: $TARGET" -ForegroundColor Gray
Write-Host ""

# Check if source exists
if (-not (Test-Path $SOURCE)) {
    Write-Host "ERROR: Source directory not found!" -ForegroundColor Red
    exit 1
}

# Check if target is accessible
if (-not (Test-Path "\\homeassistant.local\config")) {
    Write-Host "ERROR: Cannot access Samba share. Please check:" -ForegroundColor Red
    Write-Host "  1. Samba add-on is running" -ForegroundColor Yellow
    Write-Host "  2. Network connectivity to homeassistant.local" -ForegroundColor Yellow
    Write-Host "  3. Credentials are correct" -ForegroundColor Yellow
    exit 1
}

# Ensure www/community directory exists
$wwwPath = "\\homeassistant.local\config\www"
$communityPath = "\\homeassistant.local\config\www\community"

if (-not (Test-Path $wwwPath)) {
    Write-Host "Creating www directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $wwwPath | Out-Null
}

if (-not (Test-Path $communityPath)) {
    Write-Host "Creating www/community directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $communityPath | Out-Null
}

# Backup existing installation if present
if (Test-Path $TARGET) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "\\homeassistant.local\config\backups\climate_scheduler_card_$timestamp"
    Write-Host "Backing up existing installation to:" -ForegroundColor Yellow
    Write-Host "  $backupPath" -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path "\\homeassistant.local\config\backups" | Out-Null
    Copy-Item -Recurse $TARGET $backupPath
    Write-Host "Backup complete" -ForegroundColor Green
    Write-Host ""
    
    # Remove old installation
    Write-Host "Removing old installation..." -ForegroundColor Yellow
    Remove-Item -Path $TARGET -Recurse -Force
    Write-Host "Old installation removed" -ForegroundColor Green
    Write-Host ""
}

# Deploy new version
Write-Host "Deploying new version..." -ForegroundColor Cyan

# Create target directory
New-Item -ItemType Directory -Force -Path $TARGET | Out-Null

# Copy all files from dist
Copy-Item -Path "$SOURCE\*" -Destination $TARGET -Recurse -Force

Write-Host "Files copied successfully" -ForegroundColor Green
Write-Host ""

# Verify deployment
$deployedFiles = Get-ChildItem $TARGET | Measure-Object
Write-Host "Deployment verified: $($deployedFiles.Count) files deployed" -ForegroundColor Green

# List deployed files
Write-Host "`nDeployed files:" -ForegroundColor Cyan
Get-ChildItem $TARGET | ForEach-Object {
    Write-Host "  $($_.Name)" -ForegroundColor White
}

Write-Host ""
Write-Host "=== Deployment Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Card is now available at:" -ForegroundColor Cyan
Write-Host "  /local/community/climate-scheduler-card/climate-scheduler-card.js" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Add the card resource in Home Assistant:" -ForegroundColor White
Write-Host "     Settings → Dashboards → Resources → Add Resource" -ForegroundColor Gray
Write-Host "     URL: /local/community/climate-scheduler-card/climate-scheduler-card.js" -ForegroundColor Gray
Write-Host "     Type: JavaScript Module" -ForegroundColor Gray
Write-Host "  2. Clear browser cache (Ctrl+Shift+R)" -ForegroundColor White
Write-Host "  3. Add card to dashboard: type 'custom:climate-scheduler-card'" -ForegroundColor White
Write-Host ""
