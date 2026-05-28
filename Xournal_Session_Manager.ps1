# Clear the host to make it clean
Clear-Host
$host.UI.RawUI.WindowTitle = "Xournal++ Pure PowerShell Session Manager"

# Set location to the folder where this script is actually saved
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ($ScriptDir) { Set-Location $ScriptDir }

# Check for Administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[INFO] Requesting Administrator privileges..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$SessionFile = Join-Path $pwd "xournal_session.txt"
$HandleTool  = Join-Path $pwd "handle64.exe"

function Show-Menu {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "    Xournal++ Kernel Session Manager" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host " Current Directory: $pwd"
    Write-Host "========================================="
    Write-Host "1. Save Current Session"
    Write-Host "2. Restore Saved Session"
    Write-Host "3. Exit"
    Write-Host "========================================="
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Select an operation (1/2/3)"

    if ($choice -eq "1") {
        Write-Host "`nScanning OS kernel file handles..." -ForegroundColor Yellow
        if (-not (Test-Path $HandleTool)) {
            Write-Host "[FATAL ERROR] handle64.exe not found at: $HandleTool" -ForegroundColor Red
            Write-Host "Please make sure handle64.exe is in this folder.`n" -ForegroundColor Red
        } else {
            # Execute handle64, filter out everything matching .pdf or .xopp for the xournal process
            $output = & $HandleTool -p xournal -accepteula 2>$null
            $paths = $output | Select-String -Pattern '([a-zA-Z]:\\[^\"]+\.(?:pdf|xopp))' -AllMatches | ForEach-Object { $_.Matches.Value } | Select-Object -Unique
            
            if ($paths) {
                $paths | Out-File -FilePath $SessionFile -Encoding utf8
                Write-Host "Session successfully saved to: $SessionFile" -ForegroundColor Green
                $paths | ForEach-Object { Write-Host " -> Saved: $_" -ForegroundColor Gray }
            } else {
                Write-Host "Zero active files found in process memory. Are your Xournal++ PDFs open?" -ForegroundColor Red
            }
        }
        Read-Host "`nPress Enter to return to the menu"
    }
    elseif ($choice -eq "2") {
        Write-Host "`nRestoring session..." -ForegroundColor Yellow
        if (-not (Test-Path $SessionFile)) {
            Write-Host "[ERROR] No session file found at: $SessionFile" -ForegroundColor Red
        } else {
            $paths = Get-Content -Path $SessionFile
            foreach ($p in $paths) {
                if (Test-Path $p) {
                    Write-Host "Launching: $p" -ForegroundColor Green
                    Start-Process "xournalpp.exe" -ArgumentList "`"$p`""
                } else {
                    Write-Host "File no longer exists: $p" -ForegroundColor Red
                }
            }
        }
        Read-Host "`nPress Enter to return to the menu"
    }
    elseif ($choice -eq "3") {
        Write-Host "`nExiting manager..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1
        break
    }
}