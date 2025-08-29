
@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker — Start-All (v6)

rem =============================
rem  Persisted override (if any)
rem =============================
set OVERRIDE_ENV=PROJECT_DIR.env
if exist "%OVERRIDE_ENV%" (
  for /f "usebackq delims=" %%A in ("%OVERRIDE_ENV%") do set %%A
)

rem ===================================
rem  If override exists and is valid
rem ===================================
if defined PROJECT_DIR if exist "%PROJECT_DIR%" goto :FOUND

rem =========================
rem  Try common locations
rem =========================
set CANDIDATE_1=%USERPROFILE%\OneDrive\Desktop\CardTracker\ScanToCardTracker
set CANDIDATE_2=%USERPROFILE%\OneDrive - SnapBuyMarket - Personal\Desktop\Card Tracker\ScanToCardTracker
set CANDIDATE_3=%USERPROFILE%\Desktop\CardTracker\ScanToCardTracker
set CANDIDATE_4=%USERPROFILE%\Desktop\Card Tracker\ScanToCardTracker

for %%P in ("%CANDIDATE_1%" "%CANDIDATE_2%" "%CANDIDATE_3%" "%CANDIDATE_4%") do (
  if exist "%%~P" (
    set PROJECT_DIR=%%~P
    goto :FOUND
  )
)

echo [ERROR] Could not find your ScanToCardTracker folder automatically.
echo         If you know the exact path, run Set_Project_Path.bat and paste it when prompted.
echo.
pause
exit /b 1

:FOUND
echo [OK] Using PROJECT_DIR=%PROJECT_DIR%

rem =========================
rem  Persist for next time
rem =========================
> "%OVERRIDE_ENV%" echo PROJECT_DIR=%PROJECT_DIR%

rem =========================
rem  Create Logs folder
rem =========================
if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs"

rem =========================
rem  Launch watchers if not already running
rem =========================
rem Check if OCR watcher is already running by window title
tasklist /FI "WINDOWTITLE eq CardTracker — OCR Watcher" | find /I "cmd.exe" >nul
if errorlevel 1 (
  echo [LAUNCH] OCR Watcher
  start "CardTracker — OCR Watcher" cmd /c ""%~dp0Scripts\ocr_watch.bat" "%PROJECT_DIR%""
) else (
  echo [SKIP] OCR Watcher already running
)

rem AutoMove watcher
tasklist /FI "WINDOWTITLE eq CardTracker — AutoMove Watcher" | find /I "cmd.exe" >nul
if errorlevel 1 (
  echo [LAUNCH] AutoMove Watcher
  start "CardTracker — AutoMove Watcher" cmd /c ""%~dp0Scripts\automove_watch.bat" "%PROJECT_DIR%""
) else (
  echo [SKIP] AutoMove Watcher already running
)

echo.
echo [DONE] Start-All v6 complete.
timeout /t 2 >nul
exit /b 0
