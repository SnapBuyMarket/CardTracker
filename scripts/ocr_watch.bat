@echo off
setlocal
set "BASE=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "SCRIPTS=%BASE%\Scripts"

REM Try to find Python
set "PY="
if exist "%LOCALAPPDATA%\Programs\Python\Python313\python.exe" set "PY=%LOCALAPPDATA%\Programs\Python\Python313\python.exe"
if "%PY%"=="" where python >nul 2>&1 && set "PY=python"
if "%PY%"=="" where py >nul 2>&1 && set "PY=py -3"

if "%PY%"=="" (
  echo Python not found. Please install Python 3 and retry.
  pause
  exit /b 1
)

pushd "%SCRIPTS%"
echo OCR Watcher starting...
"%PY%" "%SCRIPTS%\ocr_watch.py"
popd