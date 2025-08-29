@echo off
setlocal ENABLEDELAYEDEXPANSION

REM =========================
REM CardTracker - Start All (auto-close & minimized, hardened)
REM =========================

REM Common install locations:
set "OD_DIR=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
set "DT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

REM Detect project folder
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

REM Ensure Logs folder exists
if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs" 2>nul

REM Log helper
set "LOG=%PROJECT_DIR%\Logs\launcher.log"
echo [%date% %time%] Launcher starting... > "%LOG%"

REM Check required watcher scripts
if not exist "automove_watch.bat" (
  echo [%date% %time%] ERROR: automove_watch.bat not found in Scripts >> "%LOG%"
  echo [ERROR] automove_watch.bat not found in Scripts
  popd & pause & exit /b 1
)
if not exist "ocr_watch.bat" (
  echo [%date% %time%] ERROR: ocr_watch.bat not found in Scripts >> "%LOG%"
  echo [ERROR] ocr_watch.bat not found in Scripts
  popd & pause & exit /b 1
)

REM Launch watchers minimized (plain ASCII titles), using %ComSpec%
echo [%date% %time%] Starting AutoMove... >> "%LOG%"
start "" /min "%ComSpec%" /c call "automove_watch.bat"

REM Tiny delay so window titles don't collide
timeout /t 1 /nobreak >nul

echo [%date% %time%] Starting OCR... >> "%LOG%"
start "" /min "%ComSpec%" /c call "ocr_watch.bat"

echo [%date% %time%] Done launching; exiting launcher. >> "%LOG%"

popd
exit /b 0
