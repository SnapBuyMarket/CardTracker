@echo off
setlocal
title CardTracker - Kickstart (Push Incoming to Processing once)

set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "INCOMING_DIR=%PROJECT_DIR%\Scans\Incoming"
set "PROCESSING_DIR=%PROJECT_DIR%\Scans\Processing"
set "LOG_DIR=%PROJECT_DIR%\Logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
set "LOG_FILE=%LOG_DIR%\kickstart.log"

echo Moving any images from Incoming -> Processing (one-time):
echo   %INCOMING_DIR%  -->  %PROCESSING_DIR%
echo.

set /a moved=0
for %%F in ("%INCOMING_DIR%\*.jpg" "%INCOMING_DIR%\*.jpeg" "%INCOMING_DIR%\*.png" "%INCOMING_DIR%\*.JPG" "%INCOMING_DIR%\*.JPEG" "%INCOMING_DIR%\*.PNG") do (
  if exist "%%~F" (
    echo [%DATE% %TIME%] TO_PROCESSING: %%~nxF >> "%LOG_FILE%"
    move /Y "%%~fF" "%PROCESSING_DIR%" >nul
    set /a moved+=1
    echo Moved %%~nxF
  )
)

echo.
echo Done. Moved %moved% file(s).
echo Log: %LOG_FILE%
pause
