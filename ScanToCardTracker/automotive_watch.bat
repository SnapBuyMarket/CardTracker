@echo off
setlocal ENABLEDELAYEDEXPANSION

REM === CardTracker AutoMove (LOCKED to AAAScanned Cards) ===

REM Detect PROJECT_DIR (OneDrive Desktop preferred)
set "PD1=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
set "PD2=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
if exist "C:\Users\cwall\OneDrive\Desktop" (
    set "PROJECT_DIR=%PD1%"
) else (
    set "PROJECT_DIR=%PD2%"
)

set "SOURCE=C:\Users\cwall\OneDrive\AAAScanned Cards"
set "DEST=%PROJECT_DIR%\Scans\Incoming"
set "LOG=%PROJECT_DIR%\Logs\automove_watch.log"

if not exist "%DEST%" mkdir "%DEST%"
if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs"

echo [AutoMove %DATE% %TIME%] Started (LOCKED) >> "%LOG%"
echo Source: "%SOURCE%" >> "%LOG%"
echo Dest:   "%DEST%" >> "%LOG%"

:loop
for %%F in ("%SOURCE%\*.*") do (
  set "FN=%%~nxF"
  echo [AutoMove %DATE% %TIME%] Moving: !FN! >> "%LOG%"
  move "%%~fF" "%DEST%" >> "%LOG%" 2>&1
)
timeout /t 5 >nul
goto loop
