@echo off
setlocal ENABLEDELAYEDEXPANSION

REM =========================
REM CardTracker - Diagnose OCR Launch
REM  - AutoMove starts minimized (normal)
REM  - OCR starts in a normal window with /K so errors stay visible
REM  - Logs to Logs\launcher.log
REM =========================

set "OD_DIR=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
set "DT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

if exist "%OD_DIR%\Scripts\ocr_watch.bat" set "PROJECT_DIR=%OD_DIR%"
if not defined PROJECT_DIR if exist "%DT_DIR%\Scripts\ocr_watch.bat" set "PROJECT_DIR=%DT_DIR%"

if not defined PROJECT_DIR (
  echo [ERROR] Could not find ScanToCardTracker. Looked in:
  echo   %OD_DIR%
  echo   %DT_DIR%
  pause
  exit /b 1
)

pushd "%PROJECT_DIR%\Scripts"

if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs" 2>nul
set "LOG=%PROJECT_DIR%\Logs\launcher.log"
echo [%date% %time%] DIAG: Launcher starting... >> "%LOG%"

if not exist "automove_watch.bat" (
  echo [%date% %time%] ERROR: automove_watch.bat not found >> "%LOG%"
  echo [ERROR] automove_watch.bat not found in Scripts
  popd & pause & exit /b 1
)
if not exist "ocr_watch.bat" (
  echo [%date% %time%] ERROR: ocr_watch.bat not found >> "%LOG%"
  echo [ERROR] ocr_watch.bat not found in Scripts
  popd & pause & exit /b 1
)

echo [%date% %time%] DIAG: Starting AutoMove (minimized)... >> "%LOG%"
start "" /min "%ComSpec%" /c call "automove_watch.bat"

echo [%date% %time%] DIAG: Starting OCR (VISIBLE /K via wrapper)... >> "%LOG%"
start "" "%ComSpec%" /k call "ocr_wrapper_verbose.bat"

echo [%date% %time%] DIAG: Done launching. >> "%LOG%"

popd
exit /b 0
