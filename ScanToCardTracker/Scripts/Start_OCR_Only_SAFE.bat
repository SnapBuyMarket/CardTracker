@echo off
setlocal
REM === Resolve project root from this Scripts folder ===
set "SCRIPTS_DIR=%~dp0"
for %%I in ("%SCRIPTS_DIR%\..") do set "PROJECT_DIR=%%~fI"

REM === Make sure logs exist ===
if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs"

REM === Prefer explicit Tesseract path (not relying on PATH) ===
set "TESSERACT_EXE=C:\Program Files\Tesseract-OCR\tesseract.exe"
if not exist "%TESSERACT_EXE%" (
  echo [ERR] Tesseract not found at "%TESSERACT_EXE%".
  echo       Install from the UB-Mannheim build, then retry.
  echo. & pause & exit /b 1
)

REM === Activate venv if present ===
if exist "%PROJECT_DIR%\.venv\Scripts\activate.bat" (
  call "%PROJECT_DIR%\.venv\Scripts\activate.bat"
)

REM === Log a launch marker ===
echo [LAUNCH OCR] %date% %time% >> "%PROJECT_DIR%\Logs\ocr_watch.log"

REM === Run the existing OCR watcher batch so we don't fork logic ===
REM     Use /K so errors stay on screen; also tee to a debug file.
pushd "%PROJECT_DIR%\Scripts"
cmd /K call "%PROJECT_DIR%\Scripts\ocr_watch.bat" ^>^>"%PROJECT_DIR%\Logs\ocr_launch_debug.txt" 2^>^&1
popd
