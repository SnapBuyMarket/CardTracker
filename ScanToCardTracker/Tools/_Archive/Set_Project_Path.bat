
@echo off
setlocal
title CardTracker — Set Project Path
echo Enter (or paste) the full path to your ScanToCardTracker folder, then press ENTER.
set /p USER_PATH=Path: 
if not exist "%USER_PATH%" (
  echo [ERROR] That path does not exist. Please try again.
  pause
  exit /b 1
)
> "PROJECT_DIR.env" echo PROJECT_DIR=%USER_PATH%
echo [OK] Saved. Future runs of Start_All_v6.bat will use:
echo       %USER_PATH%
pause
