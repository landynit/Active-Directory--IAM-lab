# ============================================================
# Script: mover.ps1
# Author: Paraday Home Lab
# Domain: PARADAY.com
# Purpose: Full mover workflow — moves an existing user to a
#          new department OU, removes their old department
#          group, and assigns them to the new department
#          ReadOnly group. Used when an employee changes roles.
# Requirements: Run PowerShell ISE as Administrator on DC
# ============================================================

# --- Configure these values ---
$Username      = "jsmith"
$OldDepartment = "Finance"
$NewDepartment = "IT"
# ------------------------------

$OldOU         = "OU=$OldDepartment,OU=DEPARTMENTS,DC=PARADAY,DC=com"
$NewOU         = "OU=$NewDepartment,OU=DEPARTMENTS,DC=PARADAY,DC=com"
$OldGroup      = "$OldDepartment-ReadOnly"
$NewGroup      = "$NewDepartment-ReadOnly"

Write-Host "Starting mover process for $Username..." -ForegroundColor Cyan
Write-Host "$OldDepartment --> $NewDepartment" -ForegroundColor Yellow

# Step 1 — Move user to new OU
try {
    $User = Get-ADUser -Identity $Username
    Move-ADObject -Identity $User.DistinguishedName -TargetPath $NewOU
    Write-Host "PASS: $Username moved to $NewDepartment OU" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not move user — $_" -ForegroundColor Red
    exit
}

# Step 2 — Remove old department group
try {
    Remove-ADGroupMember -Identity $OldGroup -Members $Username -Confirm:$false
    Write-Host "PASS: $Username removed from $OldGroup" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not remove from old group — $_" -ForegroundColor Red
}

# Step 3 — Assign new department group
try {
    Add-ADGroupMember -Identity $NewGroup -Members $Username
    Write-Host "PASS: $Username added to $NewGroup" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Could not add to new group — $_" -ForegroundColor Red
}

# Step 4 — Confirm final state
$User = Get-ADUser -Identity $Username -Properties MemberOf, DistinguishedName
Write-Host ""
Write-Host "=== Mover Summary ===" -ForegroundColor Cyan
Write-Host "Username:       $Username" -ForegroundColor White
Write-Host "Old Department: $OldDepartment" -ForegroundColor White
Write-Host "New Department: $NewDepartment" -ForegroundColor White
Write-Host "New OU:         $($User.DistinguishedName)" -ForegroundColor White
Write-Host "Groups:         $($User.MemberOf -join ', ')" -ForegroundColor White
Write-Host "======================" -ForegroundColor Cyan
