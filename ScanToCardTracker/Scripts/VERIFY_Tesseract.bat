@echo off
setlocal
title CardTracker - Verify Tesseract

echo Checking Tesseract on PATH...
where tesseract || echo [INFO] 'tesseract' not found on PATH.

echo.
if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
  echo Found default install: C:\Program Files\Tesseract-OCR\tesseract.exe
) else (
  echo Default install folder not found.
)

echo.
echo Running version check (if available):
tesseract --version
echo.
echo If the version prints above, Tesseract is installed and visible.
echo If not, install from: https://github.com/UB-Mannheim/tesseract/wiki
pause
