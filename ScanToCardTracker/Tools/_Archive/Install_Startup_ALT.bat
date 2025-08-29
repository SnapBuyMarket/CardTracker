
@echo off
setlocal
title CardTracker — Install Startup (ALT, no .lnk)

REM Use per-user Startup via %APPDATA%
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

if not exist "%STARTUP_DIR%" (
  echo [ERROR] Startup folder not found at:
  echo         %STARTUP_DIR%
  pause
  exit /b 1
)

REM Clean old entries (both .lnk and .cmd just in case)
if exist "%STARTUP_DIR%\CardTracker Start-All (v5).lnk" del "%STARTUP_DIR%\CardTracker Start-All (v5).lnk" >nul 2>&1
if exist "%STARTUP_DIR%\CardTracker Start-All (v6).lnk" del "%STARTUP_DIR%\CardTracker Start-All (v6).lnk" >nul 2>&1
if exist "%STARTUP_DIR%\CardTracker Start-All (v6).cmd" del "%STARTUP_DIR%\CardTracker Start-All (v6).cmd" >nul 2>&1

REM Point the startup script directly at the Start_All_v6.bat in this folder
set "TARGET=%~dp0Start_All_v6.bat"

REM Write a simple .cmd that runs Start_All_v6.bat
echo @echo off>"%STARTUP_DIR%\CardTracker Start-All (v6).cmd"
echo REM Auto-launched on user login to start CardTracker watchers>>"%STARTUP_DIR%\CardTracker Start-All (v6).cmd"
echo start "" "%TARGET%">>"%STARTUP_DIR%\CardTracker Start-All (v6).cmd"

if exist "%STARTUP_DIR%\CardTracker Start-All (v6).cmd" (
  echo [OK] Created: %STARTUP_DIR%\CardTracker Start-All (v6).cmd
) else (
  echo [ERROR] Failed to create startup script.
)

pause
