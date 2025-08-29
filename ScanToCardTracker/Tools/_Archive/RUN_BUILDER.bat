@echo off
setlocal ENABLEDELAYEDEXPANSION

REM =====================================
REM CardTracker Builder v1 (Hard-Wired)
REM One-click installer
REM =====================================

echo.
echo [CardTracker Builder] Starting...
echo.

REM --- Detect preferred Desktop path (OneDrive first) ---
set "PD1=C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker"
set "PD2=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

if exist "C:\Users\cwall\OneDrive\Desktop" (
    set "PROJECT_DIR=%PD1%"
) else (
    set "PROJECT_DIR=%PD2%"
)

echo Using PROJECT_DIR: "%PROJECT_DIR%"
echo.

REM --- Create folder structure ---
mkdir "%PROJECT_DIR%" 2>nul
mkdir "%PROJECT_DIR%\Scans\Incoming" 2>nul
mkdir "%PROJECT_DIR%\Scans\Processing" 2>nul
mkdir "%PROJECT_DIR%\Scans\Processed" 2>nul
mkdir "%PROJECT_DIR%\Scans\Errors" 2>nul
mkdir "%PROJECT_DIR%\Output" 2>nul
mkdir "%PROJECT_DIR%\Logs" 2>nul
mkdir "%PROJECT_DIR%\Scripts" 2>nul
mkdir "%PROJECT_DIR%\Tools" 2>nul

REM --- Copy payload (this ZIP's bundled files) into PROJECT_DIR ---
set "SRC=%~dp0payload"
echo Copying payload from: "%SRC%"
echo To: "%PROJECT_DIR%"
xcopy "%SRC%\*" "%PROJECT_DIR%\" /E /I /Y >nul

REM --- Seed Output CSV if missing ---
if not exist "%PROJECT_DIR%\Output\ocr_results.csv" (
    echo filename,ocr_text>"%PROJECT_DIR%\Output\ocr_results.csv"
)

REM --- Drop a breadcrumb file with chosen PROJECT_DIR ---
echo %PROJECT_DIR%>"%PROJECT_DIR%\PROJECT_DIR.txt"

REM --- Install Startup shortcut and launch watchers ---
call "%PROJECT_DIR%\Scripts\install_startup.bat"
call "%PROJECT_DIR%\Scripts\start_all.bat"

echo.
echo [CardTracker Builder] Done.
echo Project is installed at:
echo    %PROJECT_DIR%
echo.
echo A Startup shortcut was created so watchers run at login.
echo The Startup folder will open now.
echo.

call "%PROJECT_DIR%\Scripts\open_startup_folder.bat"

pause
