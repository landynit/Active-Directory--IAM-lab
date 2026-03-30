# Errors and Troubleshooting

This document covers every real error encountered during the lab setup and configuration with the exact cause and fix for each one. These are real problems that happened during the build not hypothetical scenarios.

---

## Error 1: Get-ADUser Directory Object Not Found

**Error Message:**
```
Get-ADUser : Directory object not found
```

**Cause:**
The SearchBase path in the script did not match the actual OU path. The _USERS OU was nested inside _DEPARTMENTS but the script was only looking at the top level of the domain.

**Fix:**
Ran the find-ou-paths.ps1 script to get the exact Distinguished Name of every OU. Updated the SearchBase in the script from:
```
OU=_USERS,DC=paraday,DC=home,DC=lab,DC=AD
```
To the correct nested path:
```
OU=_USERS,OU=_DEPARTMENTS,DC=paraday,DC=home,DC=lab,DC=AD
```

**Lesson Learned:**
Always verify the exact OU path using Get-ADOrganizationalUnit before writing scripts that reference specific OUs. The path must match exactly including every parent OU in the chain.

---

## Error 2: Move-ADObject Access Is Denied

**Error Message:**
```
Move-ADObject : Access is denied
```

**Cause:**
PowerShell ISE was not running as Administrator so it did not have the permissions required to move objects in Active Directory.

**Fix:**
Closed PowerShell ISE completely. Right clicked the PowerShell ISE icon and selected Run as Administrator. Ran the script again and it completed successfully.

**Lesson Learned:**
Any script that makes changes to Active Directory must be run from a PowerShell session with Administrator privileges. Always right click and Run as Administrator before running AD management scripts.

---

## Error 3: Add-ADGroupMember Insufficient Access Rights

**Error Message:**
```
Add-ADGroupMember : Insufficient access rights to perform the operation
```

**Cause:**
Same as Error 2. PowerShell ISE was not running with Administrator privileges so it could not modify group memberships in Active Directory.

**Fix:**
Reopened PowerShell ISE as Administrator and reran the script successfully.

**Lesson Learned:**
Both moving objects and modifying group memberships require Administrator rights. Make it a habit to always open PowerShell ISE as Administrator before running any AD management tasks.

---

## Error 4: GPO Not Applying to Client VM (Computer Settings)

**Symptom:**
Running gpresult /r on the client VM showed the Password Policy GPO was not in the Applied Group Policy Objects list under Computer Settings.

**Cause:**
The CLIENT1 computer account was sitting in the default Computers container at the top level of the domain instead of inside the _DEPARTMENTS OU. GPOs linked to _DEPARTMENTS only apply to objects that actually live inside that OU.

**Fix:**
Opened ADUC on the server. Found CLIENT1 in the default Computers container. Right clicked CLIENT1 and selected Move. Selected _DEPARTMENTS as the destination. Ran gpupdate /force on the client VM. Verified with gpresult /r that Password-Policy now appeared under Applied Group Policy Objects.

**Lesson Learned:**
When a computer joins the domain it goes into the default Computers container by default not into any custom OU. Always move computer accounts into the correct OU after domain join to ensure GPOs reach them.

---

## Error 5: GPO Not Applying to Client VM (User Settings)

**Symptom:**
The Screen Lock Policy GPO was not appearing under User Settings in gpresult /r output even after the computer account was moved to _DEPARTMENTS.

**Cause:**
Was logged into the client VM with the local user account which is not a domain account. User based GPOs only apply to domain user accounts not local accounts.

**Fix:**
Logged out of the local user account. Used ADUC to reset the password on a fake domain user from one of the department OUs. Logged into the client VM as PARADAY\username with the new password. Ran gpresult /r again and Screen-Lock-Policy appeared correctly under User Settings.

**Lesson Learned:**
Always test user based GPOs while logged in as a domain user account not a local account. User configuration GPOs follow the domain user account so they will never apply to a local account regardless of which machine the user is on.

---

## Error 6: VirtualBox Memory Error on VM Startup

**Error Message:**
```
VirtualBoxVM.exe Application Error: The instruction at 0x00007ffeb52da0c4 referenced memory at 0x00002DEF3090414. The memory could not be written.
```

**Cause:**
Windows Hyper-V was enabled on the host machine and was conflicting with VirtualBox causing memory access errors when trying to launch the VM.

**Fix:**
Opened PowerShell as Administrator on the host machine and ran:
```powershell
bcdedit /set hypervisorlaunchtype off
```
Restarted the host machine. VirtualBox launched the VM successfully after the restart.

**Lesson Learned:**
VirtualBox and Hyper-V cannot run at the same time on the same machine. If you get memory reference errors when starting a VM check if Hyper-V is enabled and disable it using the bcdedit command above.

---

## Error 7: VM Settings Greyed Out in VirtualBox

**Symptom:**
Tried to change the display settings on the server VM but all options were greyed out and could not be changed.

**Cause:**
The VM was in an Aborted or Saved state. VirtualBox locks all settings when a VM is not in the Powered Off state to prevent changes while the machine might still be running.

**Fix:**
Right clicked the VM in VirtualBox and selected Discard Saved State. Waited for the status to change to Powered Off. Opened Settings and all options were now editable.

**Lesson Learned:**
VirtualBox only allows settings changes when a VM is fully Powered Off. If settings are greyed out check the VM status and either shut it down properly from inside Windows or discard the saved state if the VM is stuck in an Aborted state.
