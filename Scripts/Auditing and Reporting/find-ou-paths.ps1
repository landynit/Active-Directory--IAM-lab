# ============================================================
# Script: find-ou-paths.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Lists all OUs in the domain with their full
#          Distinguished Name paths. Useful for verifying
#          OU structure and getting exact paths needed for
#          other scripts.
# Requirements: Run PowerShell as Administrator
# ============================================================

Write-Host "All Organizational Units in the domain:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Get-ADOrganizationalUnit -Filter * |
    Select-Object Name, DistinguishedName |
    Format-Table -AutoSize

Write-Host "Done." -ForegroundColor Green
