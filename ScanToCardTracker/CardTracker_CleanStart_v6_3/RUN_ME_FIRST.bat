@echo off
setlocal ENABLEDELAYEDEXPANSION

echo [CardTracker v6.3] Preparing folders and environment...
set BASE=%~dp0
set "PROJECT_DIR=%BASE%"

REM Ensure folders exist
for %%D in ("Scans\Incoming" "Scans\Processing" "Scans\Processed" "Scans\Errors" "Output" "Logs" "Scripts" "Tools") do (
  if not exist "%%~D" mkdir "%%~D"
)

REM Seed CSV if missing
if not exist "Output\ocr_results.csv" (
  echo filename,ocr_text> "Output\ocr_results.csv"
)

REM Quick checks
echo.
echo Checking Python...
where python >nul 2>nul
if errorlevel 1 (
  echo   [WARN] Python not found on PATH. OCR will fail until Python is installed.
) else (
  for /f "delims=" %%v in ('python -V 2^>^&1') do echo   [OK] %%v
)

echo Checking Tesseract...
where tesseract >nul 2>nul
if errorlevel 1 (
  if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo   [OK] Found default install at "C:\Program Files\Tesseract-OCR\tesseract.exe"
  ) else (
    echo   [WARN] tesseract not found. Install from: https://github.com/UB-Mannheim/tesseract/wiki
  )
) else (
  for /f "delims=" %%v in ('tesseract -v 2^>^&1') do (
    echo   %%v
    goto :after_tess
  )
)
:after_tess

echo.
echo Done. You can now run start_all.bat
pause