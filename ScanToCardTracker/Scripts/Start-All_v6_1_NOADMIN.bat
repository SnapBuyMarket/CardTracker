@echo off
setlocal
set "SCRIPTS_DIR=%~dp0"
for %%I in ("%SCRIPTS_DIR%\..") do set "PROJECT_DIR=%%~fI"

REM Avoid anything that touches protected folders; just launch the two consoles.

REM ----- AutoMove -----
start "CardTracker — AutoMove Watcher" cmd /K call "%PROJECT_DIR%\Scripts\automove_watch.bat"

REM ----- OCR (safe wrapper) -----
start "CardTracker — OCR Watcher" cmd /K call "%PROJECT_DIR%\Scripts\Start_OCR_Only_SAFE.bat"

echo [DONE] Start-All v6.1 launched both windows (no admin steps).
