@echo off
setlocal
title Install HEIC Support for CardTracker
echo Installing HEIC support (pillow-heif) into your current Python...
pip install pillow-heif
if errorlevel 1 (
  echo [ERR] pip install failed. Make sure Python/pip are on PATH.
  pause
  exit /b 1
)
echo [OK] Installed pillow-heif. HEIC images will now open.
pause
