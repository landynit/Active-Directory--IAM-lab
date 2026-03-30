# ============================================================
# Script: move-users-to-departments.ps1
# Author: Paraday Home Lab
# Purpose: Randomly distributes all users from the _USERS OU
#          across the 5 department OUs in Active Directory.
#          Run this after the OU structure has been created.
# Requirements: Run PowerShell ISE as Administrator
# ============================================================

$departments = @("HR", "IT", "Finance", "Sales", "Marketing")

# Get all users from the _USERS OU
$users = Get-ADUser -Filter * -SearchBase "OU=_USERS,OU=_DEPARTMENTS,DC=paraday,DC=home,DC=lab,DC=AD"

Write-Host "Found $($users.Count) users to distribute..." -ForegroundColor Cyan

foreach ($user in $users) {
    # Pick a random department for each user
    $dept = $departments | Get-Random
    $targetOU = "OU=$dept,OU=_DEPARTMENTS,DC=paraday,DC=home,DC=lab,DC=AD"

    try {
        Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
        Write-Host "Moved $($user.SamAccountName) to $dept" -ForegroundColor Green
    } catch {
        Write-Host "Failed to move $($user.SamAccountName): $_" -ForegroundColor Red
    }
}

Write-Host "Done! All users moved to departments." -ForegroundColor Cyan
