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


set "AUTOMOVE=%PROJECT_DIR%\Scripts\automove_watch.bat"

echo ============== AutoMove Target Switcher ==============
echo Current automove script:
echo   %AUTOMOVE%
echo.
echo Choose the folder AutoMove should watch:
echo   [1] C:\Users\cwall\OneDrive\aaaScanned Cards   (default)
echo   [2] C:\Users\cwall\OneDrive\Pictures\aaaScanned Cards
echo   [3] Enter a custom path
echo.
set /p CHOICE=Enter 1, 2, or 3: 

if "%CHOICE%"=="1" set "NEW=C:\Users\cwall\OneDrive\aaaScanned Cards"
if "%CHOICE%"=="2" set "NEW=C:\Users\cwall\OneDrive\Pictures\aaaScanned Cards"
if "%CHOICE%"=="3" (
  set /p NEW=Paste full folder path to watch: 
)

if not defined NEW (
  echo Invalid choice.
  pause
  exit /b 1
)

echo.
echo Setting SOURCE to:
echo   %NEW%
echo.

REM PowerShell find/replace the SOURCE line in automove_watch.bat
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "(Get-Content -Raw '%AUTOMOVE%') -replace 'set ""SOURCE=.*?""','set ""SOURCE=%NEW%""' | Set-Content -Encoding UTF8 '%AUTOMOVE%'"

if %ERRORLEVEL% NEQ 0 (
  echo [!] Failed to update automove_watch.bat
  pause
  exit /b 1
)

echo [OK] Updated.
echo.
echo Close the two watcher windows if open, then run:
echo   %PROJECT_DIR%\Scripts\start_all.bat
echo.
pause
