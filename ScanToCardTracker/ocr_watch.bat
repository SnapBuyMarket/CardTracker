@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - OCR Watcher (Fresh)

rem ---------- Locate project dir ----------
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

rem ---------- Ensure virtual environment is set up ----------
set "VENV=%PROJECT_DIR%\.venv"
set "PY=%VENV%\Scripts\python.exe"
if not exist "%PY%" (
  echo [INFO] Creating Python venv...
  py -3 -m venv "%VENV%" || goto :venv_error
  echo [INFO] Installing requirements...
  "%VENV%\Scripts\python.exe" -m pip install --upgrade pip
  "%VENV%\Scripts\pip.exe" install -r "%PROJECT_DIR%\Scripts\requirements.txt"
)

rem ---------- Tesseract detection ----------
set "TESS=C:\Program Files\Tesseract-OCR\tesseract.exe"
if exist "%TESS%" (
  set "TESSERACT_CMD=%TESS%"
) else (
  echo [WARN] Tesseract not found at "%TESS%".
  echo        If OCR fails, install from: https://github.com/UB-Mannheim/tesseract/wiki
)

rem ---------- OCR Watcher starts ----------
set "PATH=%VENV%\Scripts;%PATH%"
set "PYTHONPATH=%PROJECT_DIR%"
echo [INFO] OCR Watcher starting...
pushd "%PROJECT_DIR%"
"%PY%" "%PROJECT_DIR%\Scripts\ocr_watch.py"
set "RC=%ERRORLEVEL%"
popd
echo [INFO] OCR Watcher exited with code %RC%.
pause
exit /b %RC%

:venv_error
echo [ERROR] Failed to create Python venv. Ensure Python 3 is installed (py launcher).
pause
exit /b 1
