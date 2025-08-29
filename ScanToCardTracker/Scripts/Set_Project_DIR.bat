@echo off
setlocal
title CardTracker - Set PROJECT_DIR

echo.
echo This will set your CardTracker folder path inside BOTH scripts:
echo   - Scripts\automove_watch.bat
echo   - Scripts\ocr_watch.bat
echo.

set /p PRJ=Paste your full CardTracker folder path (e.g. C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker): 

if not exist "%PRJ%" (
  echo [ERROR] That folder does not exist: "%PRJ%"
  echo Press any key to exit...
  pause >nul
  exit /b 1
)

set "TMP=%TEMP%\ct_tmp_%RANDOM%.bat"

pushd "%~dp0"
REM Expect to be in ...\Scripts, but handle if run elsewhere
set "HERE=%CD%"
if /i not "%~n0"=="Set_Project_DIR" (
  REM In case user moved the file, try to find Scripts by relative paths
  if exist ".\automove_watch.bat" (
    set "SCRIPTS=."
  ) else if exist "..\Scripts\automove_watch.bat" (
    cd /d "..\Scripts"
    set "SCRIPTS=%CD%"
  ) else (
    echo [ERROR] Could not locate automove_watch.bat and ocr_watch.bat from: %HERE%
    echo Place this file into your Scripts folder and run again.
    pause
    exit /b 1
  )
) else (
  set "SCRIPTS=%CD%"
)

echo.
echo Updating scripts in: %SCRIPTS%
echo.

for %%F in ("automove_watch.bat" "ocr_watch.bat") do (
  if not exist "%%~F" (
    echo [WARN] Not found: %%~F
  ) else (
    echo   - Prepending PROJECT_DIR in %%~F
    >"%TMP%" echo set "PROJECT_DIR=%PRJ%"
    type "%%~F" >>"%TMP%"
    move /y "%TMP%" "%%~F" >nul
  )
)

echo.
echo PROJECT_DIR set to:
echo   %PRJ%
echo.
echo Done. You can close this window.
pause
