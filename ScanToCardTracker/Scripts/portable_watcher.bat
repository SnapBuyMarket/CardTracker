
@echo off
setlocal
title CardTracker — Portable Watcher

if "%~1"=="" (
  echo [ERROR] Missing PROJECT_DIR argument.
  pause
  exit /b 1
)
set PROJECT_DIR=%~1
set LOG=%PROJECT_DIR%\Logs\portable_watcher.log
echo [START] %DATE% %TIME% Portable watcher active >> "%LOG%"
echo Running portable watcher (demo). Close this window to stop.
:loop
timeout /t 10 >nul
echo [%DATE% %TIME%] heartbeat >> "%LOG%"
goto loop
