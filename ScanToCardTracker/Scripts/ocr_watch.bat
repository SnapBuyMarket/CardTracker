@echo off
:: Set the project directory
set PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker

:: Set the path to the correct Python executable (from python.org)
set PY="C:\Users\cwall\AppData\Local\Programs\Python\Python313\python.exe"

:: Navigate to the project directory
pushd "%PROJECT_DIR%"

:: Run the OCR script with the correct Python
"%PY%" "%PROJECT_DIR%\Scripts\ocr_watch.py"

:: Store the error level
set "RC=%ERRORLEVEL%"

:: Return to the original directory
popd

:: Exit with the error code
exit /b %RC%
