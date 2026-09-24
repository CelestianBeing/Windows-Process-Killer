[CmdletBinding()]
param(
    [switch]$DryRun
)

$targets = @(
    "brave",
    "Discord",
    "Cortana",
    "YourPhone",
    "PhoneExperienceHost",
    "MicrosoftTeams",
    "ms-teams",
    "Teams",
    "Widgets",
    "WidgetService",
    "GameBar",
    "GameBarFTServer",
    "XboxApp",
    "XboxPcAppFT",
    "XboxGameBarWidgets",
    "OneDrive",
    "Dropbox",
    "GoogleDriveFS",
    "CCXProcess",
    "Creative Cloud",
    "AdobeCollabSync",
    "AdobeIPCBroker",
    "Adobe Desktop Service",
    "AcroCEF",
    "AAM Updates Notifier",
    "ARM",
    "Update",
    "RazerCentralService",
    "RazerCentral",
    "RazerAxon",
    "RazerAxon.Player",
    "ARTAimmxService",
    "AcerCentralService",
    "AcerGAICameraService",
    "AAADSvc",
    "AcerLightingService",
    "ADESv2Svc",
    "AcerPixyService",
    "AcerDIAgent",
    "AcerCCAgent",
    "AcerServiceWrapper",
    "AcerQAAgent",
    "AcerSystemCentralService",
    "AcerEZService",
    "AcerAgentService",
    "AcerService",
    "AcerHardwareService",
    "AcerSysMonitorService",
    "AcerSysHardwareService",
    "AcerGAICameraW",
    "ACCUserPS",
    "AQAUserPS",
    "ADESv2BW",
    "NitroSense"
)

$protected = @(
    "System",
    "System Idle Process",
    "Secure System",
    "Registry",
    "smss",
    "csrss",
    "wininit",
    "services",
    "lsass",
    "LsaIso",
    "winlogon",
    "LogonUI",
    "dwm",
    "explorer",
    "sihost",
    "ShellExperienceHost",
    "StartMenuExperienceHost",
    "SearchHost",
    "SearchIndexer",
    "RuntimeBroker",
    "ApplicationFrameHost",
    "TextInputHost",
    "ctfmon",
    "fontdrvhost",
    "taskhostw",
    "taskeng",
    "dllhost",
    "WmiPrvSE",
    "spoolsv",
    "audiodg",
    "conhost",
    "csrss",
    "lsm",
    "winlogon",
    "svchost",
    "MsMpEng",
    "NisSrv",
    "SecurityHealthService",
    "SecurityHealthSystray",
    "MpDefenderCoreService",
    "MsSense",
    "Sense",
    "WdNisDrv",
    "SecurityHealthHost",
    "smartscreen",
    "TrustedInstaller",
    "TiWorker",
    "MoUsoCoreWorker",
    "UsoClient",
    "WaaSMedicAgent",
    "WindowsUpdateBox",
    "msiexec",
    "winver",
    "RuntimeBroker",
    "NVDisplay.Container",
    "nvcontainer",
    "NVIDIA Share",
    "NVIDIA Web Helper",
    "IntelCpHDCPSvc",
    "IntelAudioService",
    "IntelGraphicsCommandCenter",
    "RtkAudUService64",
    "RtkNGUI64",
    "RtkAudioService64",
    "RtkAudioUniversalService",
    "RazerCentralService",
    "RazerCentral",
    "RazerAxon",
    "RazerAxon.Player",
    "CefSharp.BrowserSubprocess",
    "powershell",
    "pwsh",
    "WindowsTerminal"
)

$protectedLookup = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase
)

foreach ($name in $protected) {
    [void]$protectedLookup.Add($name)
}

$targetLookup = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase
)

foreach ($name in $targets) {
    [void]$targetLookup.Add($name)
}

$overlap = $targetLookup.Where({ $protectedLookup.Contains($_) })

if ($overlap.Count -gt 0) {
    Write-Host "[ERROR] Target/protection conflict detected:" -ForegroundColor Red
    $overlap | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    exit 2
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $isAdmin) {
    Write-Host "[WARNING] PowerShell is not running as Administrator. Some processes may not be accessible." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       WINDOWS PROCESS CLEANUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($name in $targets) {
    if ($protectedLookup.Contains($name)) {
        Write-Host "[SKIP] Protected: $name" -ForegroundColor Yellow
        continue
    }

    $processes = Get-Process -Name $name -ErrorAction SilentlyContinue

    if (-not $processes) {
        continue
    }

    foreach ($process in $processes) {
        if ($protectedLookup.Contains($process.ProcessName)) {
            Write-Host "[SKIP] Protected: $($process.ProcessName) (PID $($process.Id))" -ForegroundColor Yellow
            continue
        }

        if ($DryRun) {
            Write-Host "[DRY-RUN] Would kill: $($process.ProcessName) (PID $($process.Id))" -ForegroundColor Magenta
            continue
        }

        try {
            Stop-Process -Id $process.Id -Force -ErrorAction Stop
            Write-Host "[KILLED] $($process.ProcessName) (PID $($process.Id))" -ForegroundColor Green
        }
        catch {
            Write-Host "[FAILED] $($process.ProcessName) (PID $($process.Id)): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "          DRY RUN COMPLETE" -ForegroundColor Cyan
}
else {
    Write-Host "          CLEANUP COMPLETE" -ForegroundColor Cyan
}
Write-Host "========================================" -ForegroundColor Cyan
