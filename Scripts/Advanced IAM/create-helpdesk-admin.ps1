# ============================================================
# Script: create-helpdesk-admin.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Creates the helpdesk.admin service account used
#          for delegation testing. This account represents a
#          real enterprise pattern where helpdesk staff get
#          limited administrative rights over specific OUs
#          rather than full Domain Admin access.
# Requirements: Run PowerShell as Domain Administrator
# Note: After running this script, use the Delegation of
#       Control Wizard in ADUC to delegate password reset
#       rights on the Finance OU to helpdesk.admin.
# ============================================================

Write-Host "Creating helpdesk.admin account..." -ForegroundColor Cyan

New-ADUser `
    -Name "Helpdesk Admin" `
    -SamAccountName "helpdesk.admin" `
    -UserPrincipalName "helpdesk.admin@paraday.com" `
    -Path "OU=IT,OU=_DEPARTMENTS,DC=paraday,DC=com" `
    -AccountPassword (ConvertTo-SecureString "Helpdesk@2026!" -AsPlainText -Force) `
    -Enabled $true

Write-Host "Account created and enabled." -ForegroundColor Green

# Verify the account
Write-Host ""
Write-Host "Verifying account:" -ForegroundColor Cyan
Get-ADUser -Identity "helpdesk.admin" | Select-Object Name, Enabled, DistinguishedName

Write-Host ""
Write-Host "Next step: Open ADUC, right click the Finance OU," -ForegroundColor Yellow
Write-Host "select Delegate Control, and grant helpdesk.admin" -ForegroundColor Yellow
Write-Host "password reset rights over Finance users only." -ForegroundColor Yellow
Write-Host "Done." -ForegroundColor Green
