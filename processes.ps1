# ============================================================
# SAFE PROCESS CLEANUP
# Windows 10/11 - Run PowerShell as Administrator
#
# Razer processes are intentionally EXCLUDED / PROTECTED.
# ============================================================

$targets = @(
    # Browser
    "brave",
    # Acer optional utilities/services
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
    # Acer/Nitro UI
    "NitroSense"
)

# ------------------------------------------------------------
# PROCESSES THAT MUST NEVER BE TOUCHED
# ------------------------------------------------------------
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
    "dwm",
    "explorer",
    # Windows security
    "MsMpEng",
    "NisSrv",
    "SecurityHealthService",
    "SecurityHealthSystray",
    # Core services host
    "svchost",
    # GPU / hardware infrastructure
    "NVDisplay.Container",
    "nvcontainer",
    "IntelCpHDCPSvc",
    "IntelAudioService",
    "RtkAudUService64",
    # Razer -- DO NOT TOUCH
    "RazerCentralService",
    "RazerAxon",
    "Razer Central",
    "RazerAxon.Player",
    "CefSharp.BrowserSubprocess"
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       PROCESS CLEANUP STARTING" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($name in $targets) {
    if ($protected -contains $name) {
        Write-Host "[SKIP] Protected: $name" -ForegroundColor Yellow
        continue
    }

    $processes = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($processes) {
        foreach ($process in $processes) {
            try {
                Stop-Process -Id $process.Id -Force -ErrorAction Stop
                Write-Host "[KILLED] $($process.ProcessName) (PID $($process.Id))" -ForegroundColor Green
            }
            catch {
                Write-Host "[FAILED] $($process.ProcessName) (PID $($process.Id))" -ForegroundColor Red
            }
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "          CLEANUP COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan