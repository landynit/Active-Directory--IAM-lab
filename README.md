# Active Directory Home Lab — IAM Security Engineer Training

## Overview

This repository documents my hands-on Active Directory home lab built to develop practical skills in Identity and Access Management security. The lab simulates a real enterprise environment running on Windows Server 2019 with a Windows 10 client machine joined to the domain. Everything in this repository was built, configured, tested, and documented by me as part of my journey toward becoming an IAM Security Engineer.

The lab covers user and group management, role based access control, Group Policy Object configuration, PowerShell automation, audit logging, and the full identity lifecycle process. All configurations have been verified working on real virtual machines and documented with screenshots as evidence.

---

## Repository Structure

```
active-directory-home-lab/
│
├── README.md                        # You are here
│
├── documentation/
│   ├── IAM_Lab_Documentation.pdf    # Full lab documentation with screenshots
│   └── IAM_Learning_Guide.pdf       # IAM security learning reference guide
│
├── scripts/
│   ├── move-users-to-departments.ps1
│   ├── assign-users-to-groups.ps1
│   ├── find-ou-paths.ps1
│   ├── get-group-members.ps1
│   ├── find-disabled-accounts.ps1
│   ├── find-inactive-accounts.ps1
│   └── offboard-user.ps1
│
├── screenshots/
│   ├── gpo/
│   │   ├── password-policy-settings.png
│   │   ├── account-lockout-settings.png
│   │   ├── screen-lock-settings.png
│   │   ├── control-panel-restriction-settings.png
│   │   ├── control-panel-restriction-notification.png
│   │   ├── usb-storage-restriction-settings.png
│   │   ├── usb-storage-restriction-notification.png
│   │   └── all-gpos-linked-to-departments.png
│   ├── audit/
│   │   ├── audit-account-logon.png
│   │   ├── audit-account-management.png
│   │   ├── audit-logon-logoff.png
│   │   ├── audit-policy-change.png
│   │   ├── audit-privilege-use.png
│   │   ├── event-viewer-4624-successful-logon.png
│   │   ├── event-viewer-4625-failed-logon.png
│   │   └── event-viewer-4776-credential-validation.png
│   ├── active-directory/
│   │   ├── ou-structure-overview.png
│   │   ├── security-groups-in-departments.png
│   │   └── user-member-of-tab.png
│   └── powershell/
│       ├── gpupdate-force-output.png
│       └── script-execution-output.png
│
└── troubleshooting/
    └── errors-and-fixes.md
```

---

## Lab Environment

| Component | Details |
|---|---|
| Virtualization Platform | VirtualBox |
| Server VM | DC (Server19) — Windows Server 2019 |
| Client VM | Client1 (Win10) — Windows 10 |
| Domain | paraday.home.lab.ad |
| Forest | paraday.home.lab.AD |
| NetBIOS Name | PARADAY |
| DC Static IP | 172.16.0.1 |
| Client IP Range | 172.16.0.100 to 172.16.0.200 (DHCP) |

---

## What Was Built

### Active Directory Structure
- Custom OU structure across 5 departments: HR, IT, Finance, Sales, and Marketing
- 1000 user accounts bulk created and distributed across departments via PowerShell
- 11 security groups implementing role based access control following least privilege
- All users assigned to department ReadOnly groups by default with selective FullAccess elevation

### Group Policy Objects
5 GPOs configured, linked to _DEPARTMENTS, and verified working on the client VM:

| GPO Name | Type | Purpose |
|---|---|---|
| Password-Policy | Computer | Enforces password complexity, length, history, and account lockout |
| Screen-Lock-Policy | User | Locks screen after 10 minutes of inactivity requiring domain password |
| Control-Panel-Restriction | User | Blocks access to Control Panel and Windows Settings for standard users |
| USB-Storage-Restriction | Computer | Denies all read and write access to removable storage devices |
| Audit-Policy | Computer | Enables security event logging for logons, account changes, and privilege use |

### PowerShell Automation
7 scripts written to automate IAM tasks including bulk user distribution, group assignment, access reviews, and offboarding workflows.

### Audit Logging
Advanced Audit Policy configured and verified with real Event Viewer log entries captured for Event IDs 4624, 4625, and 4776.

---

## Skills Demonstrated

- Active Directory administration and OU design
- Role Based Access Control and least privilege implementation
- Group Policy Object creation, configuration, and troubleshooting
- PowerShell scripting for bulk IAM automation
- Security event log analysis using Windows Event Viewer
- Identity lifecycle management: Joiner, Mover, Leaver
- Documentation and evidence collection for compliance

---

## Troubleshooting Experience

Real errors encountered and resolved during this lab are documented in the troubleshooting folder. These include GPO not applying due to computer accounts in wrong OUs, PowerShell access denied errors resolved by running as Administrator, and VirtualBox memory conflicts resolved by disabling Hyper-V.

---

## What is Next

- Fine Grained Password Policies for privileged accounts
- Identity lifecycle practice with full documentation
- Delegation of permissions to helpdesk admin account
- Full rebuild of the lab from scratch without a tutorial
- Azure Active Directory and hybrid identity in Stage 2
- Okta dashboard configuration and SSO setup in Stage 3

---

## Certifications Being Pursued

- CompTIA Security+
- Microsoft SC-300 Identity and Access Administrator

---

## Connect

Feel free to reach out if you have questions about the lab setup or want to discuss IAM security concepts.
