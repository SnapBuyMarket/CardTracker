@echo off
setlocal
title CardTracker - Restore ALL archived scripts back to Scripts

set "SCRIPTS_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts"
set "ARCHIVE_DIR=%SCRIPTS_DIR%\_Archive"

if not exist "%ARCHIVE_DIR%" (
  echo No _Archive folder found at: %ARCHIVE_DIR%
  pause
  exit /b 1
)

echo Restoring files from:
echo   %ARCHIVE_DIR%
echo to:
echo   %SCRIPTS_DIR%
echo.

pushd "%ARCHIVE_DIR%"
for %%F in (*) do (
  echo Restoring: %%~nxF
  move /Y "%%~nxF" "%SCRIPTS_DIR%" >nul
)
popd

echo.
echo Done.
pause
