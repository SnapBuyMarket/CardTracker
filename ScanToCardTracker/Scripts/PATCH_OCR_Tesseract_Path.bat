@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - Patch OCR Watcher (Tesseract Path Inject)

REM Run this from the Scripts\ folder (same place as ocr_watch.bat).
cd /d "%~dp0"

if not exist "ocr_watch.bat" (
  echo [ERROR] ocr_watch.bat not found in this folder.
  echo Place this file in your ScanToCardTracker\Scripts\ folder and run again.
  pause
  exit /b 1
)

REM Make timestamped backup
for /f "tokens=1-4 delims=/:. " %%a in ("%date% %time%") do set TS=%%d%%b%%c_%%e%%f%%g
set "BACK=ocr_watch.%TS%.bak"
copy /y "ocr_watch.bat" "%BACK%" >nul
echo Backup saved: %BACK%

REM If already injected, skip
findstr /i "TESSERACT_EXE" "ocr_watch.bat" >nul 2>&1
if "%ERRORLEVEL%"=="0" (
  echo Detected existing Tesseract variables in ocr_watch.bat. Skipping injection.
  echo You can restore from backup if needed: %BACK%
  goto :DONE
)

(
  echo REM === Injected Tesseract path safeguard (do not remove) ===
  echo set "TESSDIR=C:\Program Files\Tesseract-OCR"
  echo if exist "%%TESSDIR%%\tesseract.exe" (
  echo ^  set "PATH=%%TESSDIR%%;%%PATH%%"
  echo ^  set "TESSERACT_EXE=%%TESSDIR%%\tesseract.exe"
  echo ^) else (
  echo ^  echo [WARN] Tesseract not found at "%%TESSDIR%%". OCR may fail. 
  echo ^  echo Install from: https://github.com/UB-Mannheim/tesseract/wiki
  echo ^)
  echo REM === End inject ===
  type "ocr_watch.bat"
) > "ocr_watch.patched"

move /y "ocr_watch.patched" "ocr_watch.bat" >nul
echo Injected Tesseract safeguard into ocr_watch.bat

:DONE
echo.
echo All set. Now run start_all_diag.bat (or start_all.bat) to verify OCR launches.
pause
