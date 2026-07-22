# ============================================================
# Script: create-helpdesk-admin.ps1
# Author: Paraday Home Lab
# Domain: PARADAY.com
# Purpose: Creates a helpdesk service account in the IT OU
#          with a secure password. This account is used to
#          demonstrate delegation of control scoped to the
#          Finance OU only following the principle of least
#          privilege.
# Requirements: Run PowerShell as Administrator on DC
# ============================================================

New-ADUser -Name "Helpdesk Admin" `
    -SamAccountName "helpdesk-admin" `
    -UserPrincipalName "helpdesk-admin@PARADAY.com" `
    -Path "OU=IT,OU=DEPARTMENTS,DC=PARADAY,DC=com" `
    -AccountPassword (ConvertTo-SecureString "Helpdesk@2026!" -AsPlainText -Force) `
    -Enabled $true

Write-Host "Helpdesk admin account created in IT OU." -ForegroundColor Green
Write-Host "Next step: Delegate control of Finance OU to helpdesk-admin in ADUC." -ForegroundColor Yellow
