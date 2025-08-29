@echo off
setlocal ENABLEDELAYEDEXPANSION

REM --- Detect PROJECT_DIR (OneDrive Desktop preferred) ---
set "PD1=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
set "PD2=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

if exist "C:\Users\cwall\OneDrive\Desktop" (
    set "PROJECT_DIR=%PD1%"
) else (
    set "PROJECT_DIR=%PD2%"
)


set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
echo [install_startup] Creating Start-All shortcut in "%STARTUP%"
REM Use PowerShell to create a .lnk that points to start_all.bat
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ws = New-Object -ComObject WScript.Shell; " ^
  "$sc = $ws.CreateShortcut((Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup\CardTracker Start-All (Hardwire).lnk')); " ^
  "$sc.TargetPath = '0\Scripts\start_all.bat'; " ^
  "$sc.WorkingDirectory = '0\Scripts'; " ^
  "$sc.IconLocation = '%SystemRoot%\System32\SHELL32.dll,44'; " ^
  "$sc.Save()" ^
  -args "%PROJECT_DIR%"

exit /b 0
