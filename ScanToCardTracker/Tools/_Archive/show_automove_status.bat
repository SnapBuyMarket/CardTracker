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


echo ================= AutoMove Status ================
echo PROJECT_DIR = %PROJECT_DIR%
echo.

REM Read SOURCE directly from the installed automove_watch.bat
for /f "usebackq tokens=1,* delims==" %%A in (`findstr /B /C:"set \"SOURCE=" "%PROJECT_DIR%\Scripts\automove_watch.bat"`) do (
    set "LINE=%%A=%%B"
)
if not defined LINE (
    echo [!] Could not read SOURCE from automove_watch.bat
    goto next
)
for /f "tokens=2* delims==" %%A in ("%LINE%") do set "SOURCE=%%A"
set "SOURCE=%SOURCE:"=%"
echo SOURCE   = %SOURCE%

if exist "%SOURCE%" (
  echo [OK] Source folder exists.
  echo Listing top-level of SOURCE:
  dir /b "%SOURCE%"
) else (
  echo [MISSING] Source folder does not exist.
)

:next
echo.
echo Incoming = %PROJECT_DIR%\Scans\Incoming
echo Processed = %PROJECT_DIR%\Scans\Processed
echo.
echo --- automove_watch.log (last 20) ---
powershell -NoProfile -Command "if (Test-Path '%PROJECT_DIR%\Logs\automove_watch.log') { Get-Content '%PROJECT_DIR%\Logs\automove_watch.log' -Tail 20 } else { '  (no log yet)' }"
echo.
echo Opening SOURCE in Explorer...
start "" "%SOURCE%"
echo.
pause
