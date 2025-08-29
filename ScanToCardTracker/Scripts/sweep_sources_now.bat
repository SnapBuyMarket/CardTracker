@echo off
setlocal ENABLEDELAYEDEXPANSION
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "DEST=%PROJECT_DIR%\Scans\Incoming"
set "LOG=%PROJECT_DIR%\Logs\automove_watch.log"
if not exist "%DEST%" mkdir "%DEST%"
if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs"

echo [Sweep %DATE% %TIME%] Manual sweep started >> "%LOG%"
for %%S in ("C:\Users\cwall\OneDrive\AAAScanned Cards") do (
  if exist "%%~S" (
    for %%F in ("%%~S\*.*") do (
      set "FN=%%~nxF"
      echo [Sweep %DATE% %TIME%] Moving: !FN! from %%~S >> "%LOG%"
      move "%%~fF" "%DEST%" >> "%LOG%" 2>&1
    )
  )
)
start "" "%DEST%"
pause
