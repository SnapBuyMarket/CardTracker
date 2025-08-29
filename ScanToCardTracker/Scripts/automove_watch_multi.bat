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

set "DEST=%PROJECT_DIR%\Scans\Incoming"
set "LOG=%PROJECT_DIR%\Logs\automove_watch.log"
if not exist "%DEST%" mkdir "%DEST%"
if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs"

REM === Watch these common phone/OneDrive folders ===
set "SRC1=C:\Users\cwall\OneDrive\aaaScanned Cards"
set "SRC2=C:\Users\cwall\OneDrive\Pictures\aaaScanned Cards"
set "SRC3=C:\Users\cwall\OneDrive\Pictures\Camera Roll"
set "SRC4=C:\Users\cwall\OneDrive\Pictures\Saved pictures"
set "SRC5=C:\Users\cwall\Downloads\CardUploads"

for %%S in ("%SRC1%" "%SRC2%" "%SRC3%" "%SRC4%" "%SRC5%") do (
  if not exist "%%~S" mkdir "%%~S"
)

echo [AutoMove %DATE% %TIME%] Started >> "%LOG%"
echo Watching: >> "%LOG%"
echo   %SRC1% >> "%LOG%"
echo   %SRC2% >> "%LOG%"
echo   %SRC3% >> "%LOG%"
echo   %SRC4% >> "%LOG%"
echo   %SRC5% >> "%LOG%"
echo -> to: %DEST% >> "%LOG%"

:loop
for %%S in ("%SRC1%" "%SRC2%" "%SRC3%" "%SRC4%" "%SRC5%") do (
  for %%F in ("%%~S\*.*") do (
    set "FN=%%~nxF"
    echo [AutoMove %DATE% %TIME%] Moving: !FN! from %%~S >> "%LOG%"
    move "%%~fF" "%DEST%" >> "%LOG%" 2>&1
  )
)
timeout /t 5 >nul
goto loop
