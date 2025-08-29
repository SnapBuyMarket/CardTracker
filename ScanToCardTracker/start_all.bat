@echo off
setlocal ENABLEDELAYEDEXPANSION
title Start All Services (Fresh Install)

rem --- Start AutoMove ---
start "CardTracker - AutoMove" cmd /c "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts\auto_move.bat"

rem --- Start OCR Watcher ---
start "CardTracker - OCR Watcher" cmd /c "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts\ocr_watch.bat"

exit /b 0
