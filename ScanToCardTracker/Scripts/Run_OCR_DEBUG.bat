@echo off
title CardTracker - OCR DEBUG
echo Running OCR watcher inline so any errors stay visible...
echo.
call "%~dp0ocr_watch.bat"
echo.
echo ---- OCR watcher exited. Copy any errors above. ----
pause
