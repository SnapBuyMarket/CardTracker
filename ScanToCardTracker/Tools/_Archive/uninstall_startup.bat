@echo off
setlocal
title CardTracker - Uninstall Startup Shortcuts

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "LNK1=%STARTUP%\CardTracker - AutoMove Watcher.lnk"
set "LNK2=%STARTUP%\CardTracker - OCR Watcher.lnk"

echo Removing shortcuts from:
echo   %STARTUP%
echo.

if exist "%LNK1%" del /f /q "%LNK1%"
if exist "%LNK2%" del /f /q "%LNK2%"

echo Done.
pause
start "" "%STARTUP%"
