@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Prefer the business OneDrive if present, then personal env vars, then common defaults.
set "BASE3=C:\Users\cwall\OneDrive - SnapBuyMarket - Personal"
set "BASE1=%OneDrive%"
set "BASE2=%OneDriveCommercial%"
set "BASE4=C:\Users\cwall\OneDrive"

set "CHOSEN="
if exist "%BASE3%" set "CHOSEN=%BASE3%"
if not defined CHOSEN if exist "%BASE1%" set "CHOSEN=%BASE1%"
if not defined CHOSEN if exist "%BASE2%" set "CHOSEN=%BASE2%"
if not defined CHOSEN if exist "%BASE4%" set "CHOSEN=%BASE4%"

if not defined CHOSEN (
  echo [!] Could not find a OneDrive base folder on this PC.
  echo     Try signing into OneDrive and then run this again.
  pause
  exit /b 1
)

set "SRC=%CHOSEN%\aaaScanned Cards"
if not exist "%SRC%" mkdir "%SRC%"

REM Pin for offline use (Files On-Demand): +P = pinned, -U removes unpinned placeholder attribute.
attrib +P -U "%SRC%" >nul 2>&1

echo Source folder created/pinned here:
echo   %SRC%
echo.
echo This is the folder your phone should upload into.
echo Our AutoMove script already watches this path.
echo.
start "" "%SRC%"
pause
