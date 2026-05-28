@echo off
:: This batch file launches the PowerShell session manager with the correct permissions.
set "SCRIPT_PATH=%~dp0Xournal_Session_Manager.ps1"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%"
pause
