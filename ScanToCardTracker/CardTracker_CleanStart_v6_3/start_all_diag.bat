@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - Start All (DIAG)
cd /d "%~dp0"

echo [DIAG] AutoMove + OCR will launch in normal windows...
start "CardTracker - AutoMove Watcher (DIAG)" cmd /k "%~dp0\automove_watch.bat"
start "CardTracker - OCR Watcher (DIAG)" cmd /k "%~dp0\ocr_watch.bat"