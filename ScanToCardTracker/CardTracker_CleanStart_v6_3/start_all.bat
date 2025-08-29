@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - Start All
cd /d "%~dp0"

REM Optional delay to allow PATH/env to settle at login
timeout /t 5 /nobreak >nul

REM Launch watchers MINIMIZED
start /min "CardTracker - AutoMove Watcher" cmd /c "%~dp0\automove_watch.bat"
start /min "CardTracker - OCR Watcher" cmd /c "%~dp0\ocr_watch.bat"