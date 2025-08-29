@echo off
setlocal ENABLEDELAYEDEXPANSION
title Start OCR Now (Hotfix)

rem --- Try common install locations ---
for %%D in (
  "C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
  "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
) do (
  if exist "%%~D\Scripts\ocr_watch.bat" (
    set "PROJECT_DIR=%%~D"
    goto :found
  )
)

echo [ERROR] Could not find ScanToCardTracker folder with Scripts\ocr_watch.bat.
echo Looked in:
echo   C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker
echo   C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker
echo If your path is different, open this file and add your path to the list.
pause
exit /b 1

:found
echo [OK] Found project at: "%PROJECT_DIR%"
echo Launching OCR watcher...
pushd "%PROJECT_DIR%\Scripts"
start "CardTracker - OCR Watcher" cmd /c ""%PROJECT_DIR%\Scripts\ocr_watch.bat""
popd
exit /b 0
