@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - Kickstart (Push OneDrive images to Incoming once)

REM Paths
set "SOURCE_DIR=C:\Users\cwall\OneDrive\aaaScanned Cards"
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "INCOMING_DIR=%PROJECT_DIR%\Scans\Incoming"
set "LOG_DIR=%PROJECT_DIR%\Logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
set "LOG_FILE=%LOG_DIR%\kickstart.log"

echo Pushing images from:
echo   %SOURCE_DIR%
echo Into:
echo   %INCOMING_DIR%
echo.

set /a moved=0

for %%F in ("%SOURCE_DIR%\*.jpg" "%SOURCE_DIR%\*.jpeg" "%SOURCE_DIR%\*.png" "%SOURCE_DIR%\*.JPG" "%SOURCE_DIR%\*.JPEG" "%SOURCE_DIR%\*.PNG") do (
  if exist "%%~F" (
    for %%A in ("%%~fF") do set "s1=%%~zA"
    timeout /t 1 >nul
    if exist "%%~F" for %%B in ("%%~fF") do set "s2=%%~zB"
    if "!s1!"=="!s2!" (
      echo [%DATE% %TIME%] MOVE: %%~nxF >> "%LOG_FILE%"
      move /Y "%%~fF" "%INCOMING_DIR%" >nul
      set /a moved+=1
      echo Moved %%~nxF
    ) else (
      echo [%DATE% %TIME%] SKIP(copying): %%~nxF >> "%LOG_FILE%"
      echo Skipped (still copying): %%~nxF
    )
  )
)

echo.
echo Done. Moved %moved% file(s).
echo Log: %LOG_FILE%
pause
