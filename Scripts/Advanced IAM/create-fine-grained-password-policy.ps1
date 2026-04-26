# ============================================================
# Script: create-fine-grained-password-policy.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Creates a Fine Grained Password Policy (PSO) and
#          applies it to the IT-Admins group. This enforces
#          stricter password requirements on privileged
#          accounts compared to standard domain users.
#          Standard users: 12 char min, 5 lockout attempts
#          IT-Admins: 16 char min, 3 lockout attempts
# Requirements: Run PowerShell as Domain Administrator
# ============================================================

Write-Host "Creating IT-Admins Fine Grained Password Policy..." -ForegroundColor Cyan

# Create the Password Settings Object
New-ADFineGrainedPasswordPolicy `
    -Name "IT-Admins-PSO" `
    -Precedence 10 `
    -MinPasswordLength 16 `
    -PasswordHistoryCount 15 `
    -MaxPasswordAge "60.00:00:00" `
    -MinPasswordAge "1.00:00:00" `
    -ComplexityEnabled $true `
    -ReversibleEncryptionEnabled $false `
    -LockoutThreshold 3 `
    -LockoutDuration "01:00:00" `
    -LockoutObservationWindow "01:00:00"

Write-Host "PSO created." -ForegroundColor Green

# Apply it to the IT-Admins group
Add-ADFineGrainedPasswordPolicySubject -Identity "IT-Admins-PSO" -Subjects "IT-Admins"

Write-Host "PSO applied to IT-Admins group." -ForegroundColor Green

# Verify it is applying
Write-Host ""
Write-Host "Verifying policy is applying to elinnell (IT-Admins member):" -ForegroundColor Cyan
Get-ADUserResultantPasswordPolicy -Identity "elinnell"

Write-Host "Done." -ForegroundColor Green
