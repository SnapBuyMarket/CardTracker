@echo off
setlocal ENABLEDELAYEDEXPANSION
title Start All Services (Fresh Install)

rem --- Start AutoMove ---
start "CardTracker - AutoMove" cmd /c "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts\auto_move.bat"

rem --- Start OCR Watcher with Maximized Window ---
start "CardTracker - OCR Watcher" cmd /c "echo Running OCR Watcher... && start /max python C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts\ocr_watch.py"

exit /b 0

