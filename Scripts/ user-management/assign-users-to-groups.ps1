# ============================================================
# Script: assign-users-to-groups.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Assigns all users in each department OU to their
#          corresponding ReadOnly security group following the
#          principle of least privilege. Users already in the
#          group are silently skipped.
# Requirements: Run PowerShell as Administrator
# ============================================================

$departments = @("HR", "IT", "Finance", "Sales", "Marketing")

foreach ($dept in $departments) {
    $ouPath = "OU=$dept,OU=_DEPARTMENTS,DC=paraday,DC=com"
    $users = Get-ADUser -Filter * -SearchBase $ouPath

    Write-Host "Processing $dept department ($($users.Count) users)..." -ForegroundColor Cyan

    foreach ($user in $users) {
        Add-ADGroupMember -Identity "$dept-ReadOnly" -Members $user -ErrorAction SilentlyContinue
    }

    Write-Host "Finished $dept department." -ForegroundColor Green
}

Write-Host "Done! All users added to ReadOnly groups." -ForegroundColor Cyan
