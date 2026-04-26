# ============================================================
# Script: find-disabled-accounts.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Finds every disabled account in Active Directory.
#          Used during audits to verify former employees have
#          been properly offboarded and accounts are not
#          sitting enabled without an active owner.
# Requirements: Run PowerShell as Administrator
# ============================================================

Write-Host "Disabled accounts in Active Directory:" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

Search-ADAccount -AccountDisabled |
    Select-Object Name, SamAccountName, DistinguishedName |
    Format-Table -AutoSize

Write-Host "Done." -ForegroundColor Green
