# ============================================================
# Script: joiner.ps1
# Author: Paraday Home Lab
# Domain: PARADAY.com
# Purpose: Full joiner workflow — creates a new user account,
#          places them in the correct department OU, assigns
#          them to the department ReadOnly group following
#          least privilege, and enables the account.
# Requirements: Run PowerShell ISE as Administrator on DC
# ============================================================

# --- Configure these values for each new hire ---
$FirstName   = "John"
$LastName    = "Smith"
$Department  = "Finance"
$Password    = "Welcome@2026!"
# ------------------------------------------------

$Username    = ($FirstName[0] + $LastName).ToLower()
$FullName    = "$FirstName $LastName"
$OUPath      = "OU=$Department,OU=DEPARTMENTS,DC=PARADAY,DC=com"
$GroupName   = "$Department-ReadOnly"

Write-Host "Starting joiner process for $FullName..." -ForegroundColor Cyan

# Step 1 — Create the user account
try {
    New-ADUser `
        -Name $FullName `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@PARADAY.com" `
        -Path $OUPath `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
        -Enabled $true `
        -ChangePasswordAtLogon $true
    Write-Host "PASS: User $Username created in $Department OU" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not create user — $_" -ForegroundColor Red
    exit
}

# Step 2 — Assign to department ReadOnly group
try {
    Add-ADGroupMember -Identity $GroupName -Members $Username
    Write-Host "PASS: $Username added to $GroupName" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not add to group — $_" -ForegroundColor Red
}

# Step 3 — Confirm account exists and is enabled
$user = Get-ADUser -Identity $Username -Properties Enabled, MemberOf
Write-Host ""
Write-Host "=== Joiner Summary ===" -ForegroundColor Cyan
Write-Host "Name:       $FullName" -ForegroundColor White
Write-Host "Username:   $Username" -ForegroundColor White
Write-Host "Department: $Department" -ForegroundColor White
Write-Host "OU:         $OUPath" -ForegroundColor White
Write-Host "Enabled:    $($user.Enabled)" -ForegroundColor White
Write-Host "Groups:     $($user.MemberOf -join ', ')" -ForegroundColor White
Write-Host "=======================" -ForegroundColor Cyan
