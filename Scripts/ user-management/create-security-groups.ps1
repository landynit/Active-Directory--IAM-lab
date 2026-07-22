# ============================================================
# Script: create-security-groups.ps1
# Author: Paraday Home Lab
# Domain: PARADAY.com
# Purpose: Creates ReadOnly, ReadWrite, and Admin security
#          groups for each department OU following a tiered
#          RBAC model. All users start in ReadOnly following
#          the principle of least privilege.
# Requirements: Run PowerShell as Administrator on DC
# ============================================================

$departments = @("HR", "IT", "Finance", "Sales", "Marketing")
$roles = @("ReadOnly", "ReadWrite", "Admin")

foreach ($dept in $departments) {
    foreach ($role in $roles) {
        New-ADGroup -Name "$dept-$role" `
            -GroupScope Global `
            -GroupCategory Security `
            -Path "OU=$dept,OU=DEPARTMENTS,DC=PARADAY,DC=com"
        Write-Host "Created: $dept-$role" -ForegroundColor Green
    }
}

Write-Host "Done! All 15 security groups created." -ForegroundColor Cyan
