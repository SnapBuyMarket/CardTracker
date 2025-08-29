@echo off
setlocal ENABLEDELAYEDEXPANSION
cd /d "%~dp0"

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "LNK=%STARTUP%\CardTracker Start-All (v6.3).lnk"
set "TARGET=%~dp0start_all.bat"

if not exist "%STARTUP%" mkdir "%STARTUP%"

powershell -ExecutionPolicy Bypass -File "%~dp0Tools\create_shortcut.ps1" -TargetPath "%TARGET%" -ShortcutPath "%LNK%" -WorkingDirectory "%~dp0"

if exist "%LNK%" (
  echo [OK] Startup shortcut created: "%LNK%"
) else (
  echo [ERR] Could not create startup shortcut.
)

echo Opening Startup folder so you can verify...
call "%~dp0open_startup_folder.bat"
pause