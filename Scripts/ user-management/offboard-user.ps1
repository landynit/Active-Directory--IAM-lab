# ============================================================
# Script: offboard-user.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Performs the full Leaver process for a departing
#          employee. Disables the account, removes all group
#          memberships, and moves the account to the disabled
#          OU. Run this immediately when an employee is
#          terminated.
# Requirements: Run PowerShell as Administrator
# Usage: Set $username to the SamAccountName of the account
#        being offboarded before running.
# ============================================================

# Set the username to offboard
$username = "jsmith"
$disabledOU = "OU=_DISABLED,OU=_DEPARTMENTS,DC=paraday,DC=com"

Write-Host "Starting offboarding for: $username" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Step 1: Disable the account
try {
    Disable-ADAccount -Identity $username
    Write-Host "Step 1: Account disabled." -ForegroundColor Green
} catch {
    Write-Host "Step 1 FAILED: $_" -ForegroundColor Red
}

# Step 2: Remove from all security groups
try {
    $user = Get-ADUser -Identity $username -Properties MemberOf
    foreach ($group in $user.MemberOf) {
        Remove-ADGroupMember -Identity $group -Members $username -Confirm:$false -ErrorAction SilentlyContinue
    }
    Write-Host "Step 2: Removed from all security groups." -ForegroundColor Green
} catch {
    Write-Host "Step 2 FAILED: $_" -ForegroundColor Red
}

# Step 3: Move to _DISABLED OU
try {
    $userDN = (Get-ADUser -Identity $username).DistinguishedName
    Move-ADObject -Identity $userDN -TargetPath $disabledOU
    Write-Host "Step 3: Account moved to _DISABLED OU." -ForegroundColor Green
} catch {
    Write-Host "Step 3 FAILED - _DISABLED OU may not exist: $_" -ForegroundColor Red
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Offboarding complete for: $username" -ForegroundColor Cyan
Write-Host "Remember to document this action in your ticketing system." -ForegroundColor Yellow
