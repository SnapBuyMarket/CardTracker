@echo off
setlocal

REM --- Adjust if your Python path differs ---
set "PY=C:\Users\cwall\AppData\Local\Programs\Python\Python313\python.exe"

REM --- Project paths ---
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "SCRIPTS=%PROJECT_DIR%\Scripts"

echo Starting OCR Watcher...
pushd "%SCRIPTS%"
"%PY%" "%SCRIPTS%\ocr_watch.py"
set "RC=%ERRORLEVEL%"
popd

echo OCR Watcher exited with code %RC%
pause
