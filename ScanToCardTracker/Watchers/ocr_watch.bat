@echo off
setlocal

REM === Launch OCR Watcher ===
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "PY_SCRIPT=%PROJECT_DIR%\Scripts\ocr_watch.py"
set "LOG_DIR=%PROJECT_DIR%\Logs"
set "LOG=%LOG_DIR%\ocr_watch_launch.log"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

echo [START] %date% %time% Launching OCR Watcher >> "%LOG%"

pushd "%PROJECT_DIR%"
REM Prefer py launcher (Python 3), fallback to python
where py >nul 2>&1 && (set "PY=py -3") || (set "PY=python")

%PY% "%PY_SCRIPT%"
set "RC=%ERRORLEVEL%"
popd

echo [STOP ] %date% %time% Exit code %RC% >> "%LOG%"

if not "%RC%"=="0" (
  echo OCR Watcher exited with code %RC%. See log: "%LOG%"
  pause
)
