# ============================================================
# Script: find-inactive-accounts.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Finds active accounts that have not logged in for
#          30 or more days. These accounts are candidates for
#          review or disabling since they may belong to users
#          who have left or changed roles without offboarding.
# Requirements: Run PowerShell as Administrator
# ============================================================

$days = 30
$cutoff = (Get-Date).AddDays(-$days)

Write-Host "Active accounts with no login in the last $days days:" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

Get-ADUser -Filter {LastLogonDate -lt $cutoff -and Enabled -eq $true} `
    -Properties LastLogonDate |
    Select-Object Name, SamAccountName, LastLogonDate |
    Sort-Object LastLogonDate |
    Format-Table -AutoSize

Write-Host "Done." -ForegroundColor Green
