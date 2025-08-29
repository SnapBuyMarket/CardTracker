@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - AutoMove Watcher

REM ---------- PATH AUTODETECT ----------
set "PROJECT_DIR=%~dp0"
if exist "C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker" set "PROJECT_DIR=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
if exist "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker" set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
REM Hard override (uncomment and edit the next line if needed):
REM set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

set "IN_DIR=%PROJECT_DIR%\Scans\Incoming"
set "PROC_DIR=%PROJECT_DIR%\Scans\Processing"
set "LOG=%PROJECT_DIR%\Logs\automove_watch.log"

if not exist "%IN_DIR%" mkdir "%IN_DIR%"
if not exist "%PROC_DIR%" mkdir "%PROC_DIR%"

echo [%date% %time%] ===== AutoMove started in %PROJECT_DIR% =====>> "%LOG%"

:loop
for %%F in ("%IN_DIR%\*.jpg" "%IN_DIR%\*.jpeg" "%IN_DIR%\*.png" "%IN_DIR%\*.tif" "%IN_DIR%\*.tiff") do (
  if exist "%%~fF" (
    move /y "%%~fF" "%PROC_DIR%" >> "%LOG%" 2>&1
    echo [%date% %time%] MOVED: %%~nxF >> "%LOG%"
  )
)

REM 1-second tick
ping -n 2 127.0.0.1 >nul
goto :loop