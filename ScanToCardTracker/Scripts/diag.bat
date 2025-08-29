@echo off
setlocal ENABLEDELAYEDEXPANSION

REM --- Detect PROJECT_DIR (OneDrive Desktop preferred) ---
set "PD1=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
set "PD2=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

if exist "C:\Users\cwall\OneDrive\Desktop" (
    set "PROJECT_DIR=%PD1%"
) else (
    set "PROJECT_DIR=%PD2%"
)


echo ===== CardTracker Diagnostics =====
echo PROJECT_DIR=%PROJECT_DIR%
echo.
echo Folders:
for %%D in ("Scans\Incoming" "Scans\Processing" "Scans\Processed" "Scans\Errors" "Output" "Logs" "Scripts" "Tools") do (
  if exist "%PROJECT_DIR%\%%~D" (echo   [OK] %%~D) else (echo   [MISSING] %%~D)
)
echo.
echo Startup folder: %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\CardTracker Start-All (Hardwire).lnk" (
  echo   [OK] Startup shortcut present
) else (
  echo   [MISSING] Startup shortcut
)

echo.
echo Recent logs (last 20 lines):
echo --- automove_watch.log ---
powershell -NoProfile -Command "if (Test-Path '%PROJECT_DIR%\Logs\automove_watch.log') { Get-Content '%PROJECT_DIR%\Logs\automove_watch.log' -Tail 20 } else { '  (no log yet)' }"
echo --- ocr_watch.log ---
powershell -NoProfile -Command "if (Test-Path '%PROJECT_DIR%\Logs\ocr_watch.log') { Get-Content '%PROJECT_DIR%\Logs\ocr_watch.log' -Tail 20 } else { '  (no log yet)' }"

echo.
echo Output CSV head (first 5 lines):
powershell -NoProfile -Command "if (Test-Path '%PROJECT_DIR%\Output\ocr_results.csv') { Get-Content '%PROJECT_DIR%\Output\ocr_results.csv' -TotalCount 5 } else { '  (no csv yet)' }"

echo.
pause
