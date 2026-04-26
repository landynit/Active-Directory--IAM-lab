# ============================================================
# Script: get-group-members.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Pulls all members of a specified security group.
#          Used during access reviews to verify who has
#          access to what. Change $groupName as needed.
# Requirements: Run PowerShell as Administrator
# ============================================================

# Change this to any group name you want to audit
$groupName = "IT-Admins"

Write-Host "Members of ${groupName}:" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Get-ADGroupMember -Identity $groupName |
    Select-Object Name, SamAccountName, ObjectClass |
    Format-Table -AutoSize

Write-Host "Done." -ForegroundColor Green
