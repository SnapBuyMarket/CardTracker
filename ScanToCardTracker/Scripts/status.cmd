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

if not exist "%PROJECT_DIR%\Logs" mkdir "%PROJECT_DIR%\Logs"

set "REPORT=%PROJECT_DIR%\Logs\automove_status.txt"
echo ================= AutoMove Status ================ > "%REPORT%"
echo PROJECT_DIR = %PROJECT_DIR%>> "%REPORT%"
echo.>> "%REPORT%"

REM Read SOURCE from automove_watch.bat
set "LINE="
for /f "usebackq tokens=1,* delims==" %%A in (`findstr /B /C:"set \"SOURCE=" "%PROJECT_DIR%\Scripts\automove_watch.bat"`) do (
    set "LINE=%%A=%%B"
)
if not defined LINE (
    echo [!] Could not read SOURCE from automove_watch.bat>> "%REPORT%"
) else (
    for /f "tokens=2* delims==" %%A in ("%LINE%") do set "SOURCE=%%A"
    set "SOURCE=%SOURCE:"=%"
    echo SOURCE   = %SOURCE%>> "%REPORT%"
)

echo.>> "%REPORT%"
if exist "%SOURCE%" (
  echo [OK] Source folder exists.>> "%REPORT%"
  echo Files currently in SOURCE (top-level):>> "%REPORT%"
  dir /b "%SOURCE%" >> "%REPORT%"
) else (
  echo [MISSING] Source folder does not exist.>> "%REPORT%"
)

echo.>> "%REPORT%"
echo Incoming  = %PROJECT_DIR%\Scans\Incoming>> "%REPORT%"
echo Processed = %PROJECT_DIR%\Scans\Processed>> "%REPORT%"
echo.>> "%REPORT%"
echo --- automove_watch.log (last 20) --- >> "%REPORT%"
powershell -NoProfile -Command "if (Test-Path '%PROJECT_DIR%\Logs\automove_watch.log') { Get-Content '%PROJECT_DIR%\Logs\automove_watch.log' -Tail 20 | Out-File -Encoding utf8 '%REPORT%' -Append } else { '  (no log yet)' | Out-File -Encoding utf8 '%REPORT%' -Append }"

notepad "%REPORT%"
echo.
echo Report opened in Notepad. Leave this window open.
pause
