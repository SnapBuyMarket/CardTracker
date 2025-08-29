@echo off
REM CardTracker_StartupFix - Install a Startup shortcut that points to Start_All.bat
setlocal ENABLEDELAYEDEXPANSION

set "TARGET=%~dp0Start_All.bat"
set "WORKDIR=%~dp0"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\CardTracker - Start All.lnk"

echo.
echo [INFO] Creating startup shortcut:
echo   Target : %TARGET%
echo   Working: %WORKDIR%
echo   Output : %STARTUP%
echo.

REM Use PowerShell to create the .lnk
powershell -NoP -W Hidden -Command ^
  "$ws=New-Object -ComObject WScript.Shell; $s=$ws.CreateShortcut('%STARTUP%');" ^
  "$s.TargetPath='%TARGET%'; $s.WorkingDirectory='%WORKDIR%';" ^
  "$s.IconLocation='$env:SystemRoot\System32\shell32.dll,220'; $s.Save()"

if exist "%STARTUP%" (
  echo [OK] Shortcut created.
) else (
  echo [WARN] Could not create the shortcut automatically.
  echo        Open your Startup folder and drag a shortcut to Start_All.bat manually.
)

echo.
echo Opening Startup folder for verification...
start "" shell:startup

echo.
echo Done. This machine will auto-launch CardTracker on login.
timeout /t 2 >nul
endlocal
