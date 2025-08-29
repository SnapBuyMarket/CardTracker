@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - OCR Watcher

REM ---------- PATH AUTODETECT ----------
set "PROJECT_DIR=%~dp0"
if exist "C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker" set "PROJECT_DIR=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
if exist "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker" set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
REM Hard override (uncomment and edit the next line if needed):
REM set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

set "PROC_DIR=%PROJECT_DIR%\Scans\Processing"
set "DONE_DIR=%PROJECT_DIR%\Scans\Processed"
set "ERR_DIR=%PROJECT_DIR%\Scans\Errors"
set "OUT_CSV=%PROJECT_DIR%\Output\ocr_results.csv"
set "LOG=%PROJECT_DIR%\Logs\ocr_watch.log"
set "PY=%PROJECT_DIR%\Scripts\ocr_process.py"

if not exist "%PROC_DIR%" mkdir "%PROC_DIR%"
if not exist "%DONE_DIR%" mkdir "%DONE_DIR%"
if not exist "%ERR_DIR%" mkdir "%ERR_DIR%"
if not exist "%OUT_CSV%" echo filename,ocr_text>"%OUT_CSV%"

echo [%date% %time%] ===== OCR Watcher started in %PROJECT_DIR% =====>> "%LOG%"

:loop
REM Process any image files currently in Processing
for %%F in ("%PROC_DIR%\*.jpg" "%PROC_DIR%\*.jpeg" "%PROC_DIR%\*.png" "%PROC_DIR%\*.tif" "%PROC_DIR%\*.tiff") do (
  if exist "%%~fF" (
    echo [%date% %time%] OCR: %%~nxF >> "%LOG%"
    python "%PY%" "%%~fF" "%OUT_CSV%" >> "%LOG%" 2>&1
    if errorlevel 1 (
      echo [%date% %time%] ERROR: %%~nxF >> "%LOG%"
      move /y "%%~fF" "%ERR_DIR%" >> "%LOG%" 2>&1
    ) else (
      echo [%date% %time%] OK: %%~nxF >> "%LOG%"
      move /y "%%~fF" "%DONE_DIR%" >> "%LOG%" 2>&1
    )
  )
)

REM 1-second tick
ping -n 2 127.0.0.1 >nul
goto :loop