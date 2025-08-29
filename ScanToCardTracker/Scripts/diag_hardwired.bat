@echo off
setlocal ENABLEDELAYEDEXPANSION
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

echo ====== CardTracker (Hardwired) Diagnostics ======
echo PROJECT_DIR=%PROJECT_DIR%
echo.
echo Folders:
for %%D in ("Scans\Incoming" "Scans\Processing" "Scans\Processed" "Scans\Errors" "Output" "Logs" "Scripts") do (
  if exist "%PROJECT_DIR%\%%~D" (echo   [OK] %%~D) else (echo   [MISS] %%~D)
)
echo.
echo --- automove_watch.log (tail 20) ---
powershell -NoProfile -Command "if (Test-Path '%PROJECT_DIR%\Logs\automove_watch.log') { Get-Content '%PROJECT_DIR%\Logs\automove_watch.log' -Tail 20 } else { '  (no log yet)' }"
echo --- ocr_watch.log (tail 20) ---
powershell -NoProfile -Command "if (Test-Path '%PROJECT_DIR%\Logs\ocr_watch.log') { Get-Content '%PROJECT_DIR%\Logs\ocr_watch.log' -Tail 20 } else { '  (no log yet)' }"
echo.
echo Output CSV head:
powershell -NoProfile -Command "if (Test-Path '%PROJECT_DIR%\Output\ocr_results.csv') { Get-Content '%PROJECT_DIR%\Output\ocr_results.csv' -TotalCount 5 } else { '  (no csv yet)' }"
pause
