@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Run this INSIDE the folder you want AutoMove to watch.
REM It will overwrite automove_watch.bat to a single-source watcher.

REM Detect project dir
set "PD1=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
set "PD2=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
if exist "C:\Users\cwall\OneDrive\Desktop" (
    set "PROJECT_DIR=%PD1%"
) else (
    set "PROJECT_DIR=%PD2%"
)

set "AUTOMOVE=%PROJECT_DIR%\Scripts\automove_watch.bat"
set "SRC=%CD%"

echo Locking AutoMove to:
echo   %SRC%
echo.
echo Writing new automove_watch.bat...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$src = $env:SRC; $proj = $env:PROJECT_DIR; $content = @'
@echo off
setlocal ENABLEDELAYEDEXPANSION

set ""PROJECT_DIR=%PROJECT_DIR%""
set ""SOURCE=%SRC%""
set ""DEST=%PROJECT_DIR%\Scans\Incoming""
set ""LOG=%PROJECT_DIR%\Logs\automove_watch.log""
if not exist ""%DEST%"" mkdir ""%DEST%""
if not exist ""%PROJECT_DIR%\Logs"" mkdir ""%PROJECT_DIR%\Logs""

echo [AutoMove %DATE% %TIME%] Started (LOCKED) >> ""%LOG%""
echo Source: ""%SOURCE%"" >> ""%LOG%""
echo Dest:   ""%DEST%"" >> ""%LOG%""

:loop
for %%F in (""%SOURCE%\*.*"") do (
  set ""FN=%%~nxF""
  echo [AutoMove %DATE% %TIME%] Moving: !FN! >> ""%LOG%""
  move ""%%~fF"" ""%DEST%"" >> ""%LOG%"" 2>&1
)
timeout /t 5 >nul
goto loop
'@; Set-Content -Encoding UTF8 ($proj + '\Scripts\automove_watch.bat') $content"

if %ERRORLEVEL% NEQ 0 (
  echo [!] Failed to write %AUTOMOVE%
  pause
  exit /b 1
)

echo [OK] Updated: %AUTOMOVE%
echo Close any watcher windows, then start:
echo   %PROJECT_DIR%\Scripts\start_all.bat
pause
