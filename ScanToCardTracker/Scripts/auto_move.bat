@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker — AutoMove

REM Auto-move files from a phone-sync folder into Scans\Incoming

REM Detect project folder (same logic as ocr_watch.bat)
set OD_PERSONAL=C:\Users\cwall\OneDrive - SnapBuyMarket - Personal\Desktop\Card Tracker\ScanToCardTracker
set OD_STD=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker
set DT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker

REM Uncomment to force a specific path:
REM set PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker

if not defined PROJECT_DIR (
  if exist "%OD_PERSONAL%" set PROJECT_DIR=%OD_PERSONAL%
)
if not defined PROJECT_DIR (
  if exist "%OD_STD%" set PROJECT_DIR=%OD_STD%
)
if not defined PROJECT_DIR (
  if exist "%DT_DIR%" set PROJECT_DIR=%DT_DIR%
)

if not defined PROJECT_DIR (
  echo [ERROR] Could not auto-detect PROJECT_DIR. Edit this file and set it manually.
  pause
  exit /b 1
)

set INCOMING=%PROJECT_DIR%\Scans\Incoming

REM Try common OneDrive phone-dump folders (adjust if needed)
set CAND1=C:\Users\cwall\OneDrive\aaaScanned Cards
set CAND2=C:\Users\cwall\OneDrive\Pictures\aaaScanned Cards
set CAND3=C:\Users\cwall\OneDrive\Documents\aaaScanned Cards

if exist "%CAND1%" set SOURCE=%CAND1%
if not defined SOURCE if exist "%CAND2%" set SOURCE=%CAND2%
if not defined SOURCE if exist "%CAND3%" set SOURCE=%CAND3%

if not defined SOURCE (
  echo [WARN] Could not find your "aaaScanned Cards" folder. Defaulting to OneDrive root.
  set SOURCE=C:\Users\cwall\OneDrive\aaaScanned Cards
)

echo Auto-moving from:
echo   SOURCE : %SOURCE%
echo   DEST   : %INCOMING%
echo Press CTRL+C to stop.

:loop
for %%f in ("%SOURCE%\*") do (
  if exist "%%~f" (
    move /Y "%%~f" "%INCOMING%" >nul 2>&1
  )
)
timeout /t 5 >nul
goto :loop
