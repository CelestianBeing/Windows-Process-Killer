# Windows Process Cleanup

A PowerShell utility for manually terminating selected optional background applications and OEM utility processes on Windows 10/11.

The project is intentionally process-focused. It does not uninstall software, delete files, modify the registry, disable Windows services, or change startup configuration.

## Features

- Explicit allowlist of processes that may be terminated
- Expanded protection list for Windows, security, shell, graphics, audio, and hardware processes
- Detects target/protection-list conflicts before execution
- Administrator check
- Dry-run mode
- Clear execution results
- No automatic service disabling
- No registry modifications

## Important

This script uses `Stop-Process -Force`. A process can lose unsaved state when it is terminated.

Some optional processes are included because they may consume resources in the background, but whether a process is "bloatware" depends on how the computer is configured and which applications/features the owner uses.

The script does not guarantee a performance improvement.

Windows has critical system services and protected processes that should not be terminated casually. Microsoft documents critical services including `smss.exe`, `csrss.exe`, `wininit.exe`, `lsass.exe`, `services.exe`, `winlogon.exe`, and certain `svchost.exe` instances. See the Microsoft references below.

## Requirements

- Windows 10 or Windows 11
- Windows PowerShell 5.1 or PowerShell 7+
- Administrator privileges recommended

## Usage

Open PowerShell as Administrator.

Preview what would be terminated:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\processes.ps1 -DryRun
```

Actually terminate matching processes:

```powershell
.\processes.ps1
```

The script only acts on process names explicitly present in `$targets`.

## What is included

### OEM and device utilities

The target list includes optional Acer/Nitro utilities found in the original project, such as Acer Central, Acer lighting, camera, hardware and NitroSense components.

### Common optional applications

The target list also includes selected application processes such as:

- Brave
- Discord
- Microsoft Teams
- Xbox/Game Bar components
- Windows Widgets
- Phone Link components
- Adobe background components
- Creative Cloud components
- OneDrive
- Dropbox
- Google Drive

These applications are not inherently unwanted. They are included because some users may prefer to stop them temporarily.

If you actively use an application, remove its process name from `$targets`.


## Safety model

The project uses two lists:

`$targets`
Processes explicitly eligible for termination.

`$protected`
Processes that must not be terminated by this script.

The protection list is deliberately broader than the target list. It includes Windows authentication, system, shell, security, update, graphics, audio and other infrastructure processes.

The protection list is a defense-in-depth mechanism, not a substitute for reviewing the target list.

## Limitations

- Process names can vary between Windows versions and software versions.
- Some applications automatically restart after being terminated.
- Some processes may require elevation to terminate.
- Some OEM components may be required for hardware-specific features.
- Killing a process does not uninstall the associated application.
- A process can have multiple instances.
- A process name alone does not establish whether the underlying executable is legitimate.

## Recommendations

Run `-DryRun` first.

Do not add Windows system processes to `$targets`.

Do not use this project as a replacement for uninstalling unwanted software.

Do not disable Microsoft Defender, Windows Update, authentication, networking, or other security-critical components with a process-killing script.

## Microsoft documentation

- Critical system services:
  https://learn.microsoft.com/en-us/windows/win32/rstmgr/critical-system-services
- Essential Windows services:
  https://learn.microsoft.com/en-us/windows/privacy/essential-services-and-connected-experiences
- Windows process security:
  https://learn.microsoft.com/en-us/windows/win32/procthread/process-security-and-access-rights
- Windows authentication processes:
  https://learn.microsoft.com/en-us/windows-server/security/windows-authentication/credentials-processes-in-windows-authentication

## License

MIT License. See `LICENSE`.

## Disclaimer

Use at your own risk. The authors are not responsible for data loss, application instability, hardware-feature loss, system instability, or other consequences caused by terminating processes.

Test changes on a non-critical machine before deploying them broadly.
