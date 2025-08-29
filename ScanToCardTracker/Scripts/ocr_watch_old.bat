@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - OCR Watcher

set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

set "IN=%PROJECT_DIR%\Scans\Incoming"
set "PROC=%PROJECT_DIR%\Scans\Processing"
set "OK=%PROJECT_DIR%\Scans\Processed"
set "ERR=%PROJECT_DIR%\Scans\Errors"
set "OUT=%PROJECT_DIR%\Output"
set "LOG=%PROJECT_DIR%\Logs\ocr_watch.log"
set "CSV=%OUT%\ocr_results.csv"

if not exist "%PROC%" mkdir "%PROC%"
if not exist "%OK%" mkdir "%OK%"
if not exist "%ERR%" mkdir "%ERR%"
if not exist "%OUT%" mkdir "%OUT%"
if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs"

if not exist "%CSV%" (
  echo filename,ocr_text>"%CSV%"
)

echo [%date% %time%] ===== OCR Watcher started =====>>"%LOG%"
echo Watching: %IN%
echo Output : %CSV%
echo.
echo Press CTRL+C to stop.

where tesseract >nul 2>&1
if %ERRORLEVEL%==0 (
  set "OCR_AVAILABLE=1"
) else (
  set "OCR_AVAILABLE=0"
  echo [%date% %time%] WARNING: Tesseract not found; will record filename only.>>"%LOG%"
)

:loop
for %%f in ("%IN%\*.jpg" "%IN%\*.jpeg" "%IN%\*.png" "%IN%\*.tif" "%IN%\*.tiff" "%IN%\*.JPG" "%IN%\*.JPEG" "%IN%\*.PNG" "%IN%\*.TIF" "%IN%\*.TIFF") do (
  if exist "%%~f" (
    set "FN=%%~nxf"
    echo Processing: !FN!
    echo [%date% %time%] INCOMING: !FN! >>"%LOG%"
    move "%%~f" "%PROC%\!FN!" >nul 2>&1
    if errorlevel 1 (
      echo [%date% %time%] MOVE->PROC FAILED: !FN! >>"%LOG%"
      move "%PROC%\!FN!" "%ERR%\!FN!" >nul 2>&1
      goto nextfile
    )

    set "TEXT="
    if "!OCR_AVAILABLE!"=="1" (
      set "BASE=%PROC%\%%~nf"
      tesseract "%PROC%\!FN!" "!BASE!" -l eng >nul 2>&1
      if exist "!BASE!.txt" (
        for /f "usebackq delims=" %%L in ("!BASE!.txt") do (
          set "LINE=%%L"
          set "TEXT=!TEXT!!LINE! "
        )
        del "!BASE!.txt" >nul 2>&1
      )
    )

    set "TEXT=!TEXT:""=""!"
    set "TEXT=!TEXT:(=[!"
    set "TEXT=!TEXT:)=]!"

    >>"%CSV%" echo "!FN!","!TEXT!"

    if errorlevel 1 (
      echo [%date% %time%] CSV WRITE FAILED: !FN! >>"%LOG%"
      move "%PROC%\!FN!" "%ERR%\!FN!" >nul 2>&1
    ) else (
      move "%PROC%\!FN!" "%OK%\!FN!" >nul 2>&1
      echo [%date% %time%] OK: !FN! >>"%LOG%"
    )
  )
  :nextfile
)
timeout /t 3 >nul
goto loop
