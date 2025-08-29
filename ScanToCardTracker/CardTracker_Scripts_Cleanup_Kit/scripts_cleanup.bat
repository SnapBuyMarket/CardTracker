@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - Scripts Folder Cleanup (safe archive)

REM === CONFIG: change if your path differs ===
set "SCRIPTS_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts"
set "ARCHIVE_DIR=%SCRIPTS_DIR%\_Archive"
set "LOG_FILE=%SCRIPTS_DIR%\_cleanup_moved.txt"

if not exist "%SCRIPTS_DIR%" (
  echo ERROR: Scripts folder not found: %SCRIPTS_DIR%
  pause
  exit /b 1
)

echo Cleaning: %SCRIPTS_DIR%
echo Archive  : %ARCHIVE_DIR%
echo Log      : %LOG_FILE%
echo.

if not exist "%ARCHIVE_DIR%" mkdir "%ARCHIVE_DIR%"

REM === Keep list (case-insensitive name match) ===
set KEEP=;automove_watch.bat;ocr_watch.bat;start_all.bat;start_all_diag.bat;install_startup.bat;open_startup_folder.bat;kickstart_push_now.bat;kickstart_to_processing.bat;ocr_basic.py;ocr_pipeline.py;ocr_process.py;README.txt;

echo Creating move log...
echo ===== Scripts Cleanup moved files ===== > "%LOG_FILE%"
echo Run date: %DATE% %TIME% >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

pushd "%SCRIPTS_DIR%"

for %%F in (*) do (
  if /I not "%%~nxF"=="_Archive" (
    set "NAME=%%~nxF"
    set "L=;%NAME%"
    echo !KEEP! | findstr /I /C:"!L!" >nul
    if errorlevel 1 (
      echo Moving: %%~nxF
      echo %%~nxF >> "%LOG_FILE%"
      move /Y "%%~nxF" "%ARCHIVE_DIR%" >nul
    ) else (
      echo Keeping: %%~nxF
    )
  )
)

echo.
echo DONE. Kept essential files; everything else moved to _Archive.
echo A list of moved files is saved at: %LOG_FILE%
echo You can restore any file by moving it back from _Archive.
echo.
pause
popd
exit /b 0
