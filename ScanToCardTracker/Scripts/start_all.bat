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


echo [start_all] PROJECT_DIR=%PROJECT_DIR%

REM Start the AutoMove and OCR watchers in separate windows (minimized).
start "CardTracker — AutoMove Watcher" /min cmd /c ""%PROJECT_DIR%\Scripts\automove_watch.bat""
start "CardTracker — OCR Watcher" /min cmd /c ""%PROJECT_DIR%\Scripts\ocr_watch.bat""

exit /b 0
