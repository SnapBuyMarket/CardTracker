@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker - Install Startup Shortcuts

REM ===== Paths (edit if you installed somewhere else) =====
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "SCRIPTS_DIR=%PROJECT_DIR%\Scripts"
set "AUTO=%SCRIPTS_DIR%\automove_watch.bat"
set "OCR=%SCRIPTS_DIR%\ocr_watch.bat"

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo Installing startup shortcuts to:
echo   %STARTUP%
echo.
if not exist "%AUTO%" (
  echo ERROR: Not found: %AUTO%
  echo Make sure automove_watch.bat is in the Scripts folder.
  pause
  exit /b 1
)
if not exist "%OCR%" (
  echo WARNING: Not found: %OCR%
  echo OCR shortcut will be skipped. Put ocr_watch.bat in Scripts later and re-run this installer.
  set "SKIP_OCR=1"
)

REM ===== Create AutoMove shortcut =====
echo Creating: CardTracker - AutoMove Watcher.lnk
powershell -NoP -C "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\CardTracker - AutoMove Watcher.lnk'); $s.TargetPath='%AUTO%'; $s.WorkingDirectory='%SCRIPTS_DIR%'; $s.IconLocation='$env:SystemRoot\System32\shell32.dll,21'; $s.Save()"

REM ===== Create OCR shortcut (if present) =====
if not defined SKIP_OCR (
  echo Creating: CardTracker - OCR Watcher.lnk
  powershell -NoP -C "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\CardTracker - OCR Watcher.lnk'); $s.TargetPath='%OCR%'; $s.WorkingDirectory='%SCRIPTS_DIR%'; $s.IconLocation='$env:SystemRoot\System32\shell32.dll,21'; $s.Save()"
)

echo.
echo DONE. These will launch on next sign-in.
echo You can also open the Startup folder now.
echo.
pause
start "" "%STARTUP%"
exit /b 0
