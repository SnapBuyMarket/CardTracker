@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - Patch OCR Watcher (Auto-Detect Tesseract)

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

REM Try to locate tesseract.exe in common locations
set "CANDIDATE="

if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" set "CANDIDATE=C:\Program Files\Tesseract-OCR"
if not defined CANDIDATE if exist "C:\Program Files (x86)\Tesseract-OCR\tesseract.exe" set "CANDIDATE=C:\Program Files (x86)\Tesseract-OCR"
if not defined CANDIDATE if exist "%LOCALAPPDATA%\Programs\Tesseract-OCR\tesseract.exe" set "CANDIDATE=%LOCALAPPDATA%\Programs\Tesseract-OCR"
if not defined CANDIDATE if exist "%USERPROFILE%\AppData\Local\Programs\Tesseract-OCR\tesseract.exe" set "CANDIDATE=%USERPROFILE%\AppData\Local\Programs\Tesseract-OCR"

REM Fallback: do a recursive search from Program Files and LocalAppData (can be slow)
if not defined CANDIDATE (
  for /f "delims=" %%p in ('where /r "C:\Program Files" tesseract.exe 2^>nul') do (
    set "CANDIDATE=%%~dpp"
    goto :found
  )
)
if not defined CANDIDATE (
  for /f "delims=" %%p in ('where /r "%LOCALAPPDATA%\Programs" tesseract.exe 2^>nul') do (
    set "CANDIDATE=%%~dpp"
    goto :found
  )
)

:found
if defined CANDIDATE (
  echo Found Tesseract at: !CANDIDATE!
) else (
  echo [WARN] Could not auto-locate tesseract.exe.
  echo You can still proceed; the patch will add a warning and continue.
)

REM Write patched file with auto-detect block at top
(
  echo REM === Injected Tesseract auto-detect (do not remove) ===
  echo set "TESSDIR=!CANDIDATE!"
  echo if not defined TESSDIR (
  echo ^  if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" set "TESSDIR=C:\Program Files\Tesseract-OCR"
  echo ^  if not defined TESSDIR if exist "C:\Program Files (x86)\Tesseract-OCR\tesseract.exe" set "TESSDIR=C:\Program Files (x86)\Tesseract-OCR"
  echo ^  if not defined TESSDIR if exist "%%LOCALAPPDATA%%\Programs\Tesseract-OCR\tesseract.exe" set "TESSDIR=%%LOCALAPPDATA%%\Programs\Tesseract-OCR"
  echo ^  if not defined TESSDIR if exist "%%USERPROFILE%%\AppData\Local\Programs\Tesseract-OCR\tesseract.exe" set "TESSDIR=%%USERPROFILE%%\AppData\Local\Programs\Tesseract-OCR"
  echo )
  echo if defined TESSDIR (
  echo ^  set "PATH=%%TESSDIR%%;%%PATH%%"
  echo ^  set "TESSERACT_EXE=%%TESSDIR%%\tesseract.exe"
  echo ^  echo Using Tesseract at "%%TESSDIR%%"
  echo ) else (
  echo ^  echo [WARN] Tesseract not found on this system. OCR will fail until installed.
  echo ^  echo Install from: https://github.com/UB-Mannheim/tesseract/wiki
  echo )
  echo REM === End auto-detect ===
  type "ocr_watch.bat"
) > "ocr_watch.patched"

move /y "ocr_watch.patched" "ocr_watch.bat" >nul
echo Injection complete.

echo.
echo Now run start_all_diag.bat and confirm OCR launches.
pause
