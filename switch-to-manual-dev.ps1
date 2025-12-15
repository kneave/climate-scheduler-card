#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Switch from HACS to manual development mode

.DESCRIPTION
    Instructions to switch to manual resource registration for development
#>

Write-Host "`n=== Switch to Manual Development Mode ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "To use manual deployments instead of HACS, follow these steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Go to Settings → Dashboards → Resources (top right menu)" -ForegroundColor White
Write-Host "2. Find 'Climate Scheduler Card' in the list" -ForegroundColor White
Write-Host "3. Click the three dots → Delete" -ForegroundColor White
Write-Host "4. Click 'Add Resource'" -ForegroundColor White
Write-Host "5. Enter URL: /local/community/climate-scheduler-card/climate-scheduler-card.js" -ForegroundColor White
Write-Host "6. Select Type: JavaScript Module" -ForegroundColor White
Write-Host "7. Click Create" -ForegroundColor White
Write-Host ""
Write-Host "After this, your deploy-to-production.ps1 script will work without HACS interference." -ForegroundColor Green
Write-Host ""
Write-Host "To switch back to HACS:" -ForegroundColor Yellow
Write-Host "1. Delete the manual resource registration" -ForegroundColor White
Write-Host "2. Go to HACS → Frontend" -ForegroundColor White
Write-Host "3. Find Climate Scheduler Card → Redownload" -ForegroundColor White
Write-Host ""
