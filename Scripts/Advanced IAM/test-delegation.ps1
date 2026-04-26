# ============================================================
# Script: test-delegation.ps1
# Author: Paraday Home Lab
# Domain: paraday.com
# Purpose: Tests that the helpdesk.admin delegation is
#          correctly scoped to the Finance OU only.
#          Test 1: Reset a Finance user password - should SUCCEED
#          Test 2: Reset an HR user password - should FAIL
#          Run this while logged in AS helpdesk.admin to
#          verify the delegation is working correctly.
# Requirements: Run PowerShell as helpdesk.admin
# ============================================================

Write-Host "Testing delegation scope for helpdesk.admin" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Import the AD module (needed on Client1 with RSAT installed)
Import-Module ActiveDirectory

# Test 1: Reset Finance user password (should succeed)
Write-Host ""
Write-Host "Test 1: Resetting Finance user aweyer password..." -ForegroundColor Yellow
try {
    Set-ADAccountPassword -Identity "aweyer" `
        -NewPassword (ConvertTo-SecureString "NewPass@2026!" -AsPlainText -Force) `
        -Reset
    Write-Host "PASS: Finance user password reset succeeded." -ForegroundColor Green
} catch {
    Write-Host "FAIL: Finance user password reset failed - $_" -ForegroundColor Red
}

# Test 2: Reset HR user password (should fail - access denied)
Write-Host ""
Write-Host "Test 2: Attempting to reset HR user kmantooth password..." -ForegroundColor Yellow
try {
    Set-ADAccountPassword -Identity "kmantooth" `
        -NewPassword (ConvertTo-SecureString "NewPass@2026!" -AsPlainText -Force) `
        -Reset
    Write-Host "UNEXPECTED PASS: This should have failed." -ForegroundColor Red
} catch {
    Write-Host "PASS: Access denied for HR user as expected." -ForegroundColor Green
    Write-Host "Error: $_" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Delegation test complete." -ForegroundColor Cyan
Write-Host "If Test 1 passed and Test 2 failed the delegation is working correctly." -ForegroundColor Cyan
