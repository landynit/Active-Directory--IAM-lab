# ============================================================
# Script: leaver.ps1
# Author: Paraday Home Lab
# Domain: PARADAY.com
# Purpose: Full leaver workflow — disables the account,
#          removes all group memberships, moves the account
#          to a Disabled OU, resets the password to a random
#          secure value, and stamps the description with the
#          date and reason so there is an audit trail.
# Requirements: Run PowerShell ISE as Administrator on DC
# ============================================================

# --- Configure these values ---
$Username = "jsmith"
$Reason   = "Employee terminated"
# ------------------------------

$DisabledOU = "OU=_ADMINS,DC=PARADAY,DC=com"
$Date       = Get-Date -Format "yyyy-MM-dd"
$RandomPass = -join ((65..90) + (97..122) + (48..57) + (33..47) | Get-Random -Count 16 | ForEach-Object {[char]$_})

Write-Host "Starting leaver process for $Username..." -ForegroundColor Cyan

# Step 1 — Disable the account
try {
    Disable-ADAccount -Identity $Username
    Write-Host "PASS: $Username account disabled" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not disable account — $_" -ForegroundColor Red
    exit
}

# Step 2 — Remove all group memberships
try {
    $User = Get-ADUser -Identity $Username -Properties MemberOf
    foreach ($Group in $User.MemberOf) {
        Remove-ADGroupMember -Identity $Group -Members $Username -Confirm:$false
        Write-Host "PASS: Removed from $Group" -ForegroundColor Green
    }
} catch {
    Write-Host "FAIL: Could not remove groups — $_" -ForegroundColor Red
}

# Step 3 — Reset password to random secure value
try {
    Set-ADAccountPassword -Identity $Username `
        -NewPassword (ConvertTo-SecureString $RandomPass -AsPlainText -Force) `
        -Reset
    Write-Host "PASS: Password reset to random secure value" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not reset password — $_" -ForegroundColor Red
}

# Step 4 — Stamp description with date and reason
try {
    Set-ADUser -Identity $Username -Description "DISABLED $Date — $Reason"
    Write-Host "PASS: Description stamped with date and reason" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not update description — $_" -ForegroundColor Red
}

# Step 5 — Move to Disabled OU
try {
    $User = Get-ADUser -Identity $Username
    Move-ADObject -Identity $User.DistinguishedName -TargetPath $DisabledOU
    Write-Host "PASS: $Username moved to Disabled OU" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not move account — $_" -ForegroundColor Red
}

# Step 6 — Confirm final state
$User = Get-ADUser -Identity $Username -Properties Enabled, MemberOf, Description
Write-Host ""
Write-Host "=== Leaver Summary ===" -ForegroundColor Cyan
Write-Host "Username:    $Username" -ForegroundColor White
Write-Host "Enabled:     $($User.Enabled)" -ForegroundColor White
Write-Host "Groups:      $($User.MemberOf.Count) remaining" -ForegroundColor White
Write-Host "Description: $($User.Description)" -ForegroundColor White
Write-Host "Location:    $($User.DistinguishedName)" -ForegroundColor White
Write-Host "Reason:      $Reason" -ForegroundColor White
Write-Host "======================" -ForegroundColor Cyan
