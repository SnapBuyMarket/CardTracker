@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - OCR Watcher (DIAG)

REM Ensure we run from this file's folder
cd /d "%~dp0"

REM Resolve paths
for %%I in (.) do set "SCRIPTS_DIR=%%~fI"
set "PROJECT_DIR=%SCRIPTS_DIR%\.."

REM Ensure Logs exists
if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs" 2>nul
set "LOG=%PROJECT_DIR%\Logs\ocr_watch_last.log"

echo ==================================================
echo OCR Watcher Diagnostic Wrapper
echo   Scripts: %SCRIPTS_DIR%
echo   Project: %PROJECT_DIR%
echo   Time   : %date% %time%
echo ==================================================
echo/

>> "%LOG%" (
  echo ==================================================
  echo [%date% %time%] --- BEGIN DIAG ---
  echo SCRIPTS_DIR=%SCRIPTS_DIR%
  echo PROJECT_DIR=%PROJECT_DIR%
)

REM Show Python and Tesseract availability
echo Checking Python and Tesseract...
where python >nul 2>&1 && (python --version) || echo Python NOT FOUND
where tesseract >nul 2>&1 && (tesseract --version) || echo Tesseract NOT FOUND
echo/

>> "%LOG%" (
  echo --- PATH CHECKS ---
  where python 2^>^&1
  python --version 2^>^&1
  where tesseract 2^>^&1
  tesseract --version 2^>^&1
)

REM Activate venv if present
set "VENV_DIR=%PROJECT_DIR%\.venv"
if exist "%VENV_DIR%\Scripts\activate.bat" (
  echo Activating venv: %VENV_DIR%
  call "%VENV_DIR%\Scripts\activate.bat"
  echo VENV activated.
  >> "%LOG%" echo Activated venv: %VENV_DIR%
) else (
  echo No venv found at %VENV_DIR% (continuing anyway)
  >> "%LOG%" echo No venv at %VENV_DIR%
)

echo/
echo Launching the real OCR watcher now...
echo (This window will stay open and show errors if it exits.)
echo/
echo === ocr_watch.bat output starts ===
>> "%LOG%" echo [%date% %time%] CALL ocr_watch.bat
call "ocr_watch.bat"
set "ERR=%ERRORLEVEL%"
echo === ocr_watch.bat output ended with code %ERR% ===
>> "%LOG%" echo [%date% %time%] EXIT CODE: %ERR%

if not "%ERR%"=="0" (
  echo/
  echo !!! OCR watcher exited with error code %ERR% !!!
  echo See log: %PROJECT_DIR%\Logs\ocr_watch_last.log
  echo/
  pause
)

exit /b %ERR%
