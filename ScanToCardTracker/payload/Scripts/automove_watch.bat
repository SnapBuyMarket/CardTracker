@echo off
setlocal ENABLEDELAYEDEXPANSION
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "SOURCE=C:\Users\cwall\OneDrive - SnapBuyMarket - Personal\AAAScanned Cards"
set "DEST=%PROJECT_DIR%\Scans\Incoming"
set "LOG=%PROJECT_DIR%\Logs\automove_watch.log"

for %%D in ("%DEST%" "%PROJECT_DIR%\Logs") do if not exist "%%~D" mkdir "%%~D"

echo [AutoMove %DATE% %TIME%] Started (LOCKED SnapBuyBusiness) >> "%LOG%"
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
