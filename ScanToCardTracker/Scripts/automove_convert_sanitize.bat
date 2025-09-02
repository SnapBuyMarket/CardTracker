@echo on
setlocal

REM === AutoMove, Convert, and Sanitize Images ===
REM Watches OneDrive\AAAScanned, converts PNG->JPG, moves JPG/JPEG to Incoming

REM ----- PATHS (edit only if you change folders) -----
set "SOURCE=C:\Users\cwall\OneDrive\AAAScanned"
set "DEST=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
set "LOG=%~dp0automove_log.txt"

REM ----- STARTUP -----
if not exist "%DEST%" mkdir "%DEST%"
echo.>>"%LOG%"
echo [START] %date% %time% Watching "%SOURCE%" -> "%DEST%" >>"%LOG%"
title AutoMove / Convert / Sanitize - Watching "%SOURCE%"

REM Check ImageMagick availability (magick)
where magick >nul 2>&1
if errorlevel 1 (
  echo [ERROR] ImageMagick (magick) not found in PATH. >>"%LOG%"
  echo ImageMagick not found. Press Ctrl+C to exit.
  pause
)

:loop
REM --- Convert all PNG files to JPG in DEST, then move original PNG into DEST as well (optional) ---
for %%F in ("%SOURCE%\*.png") do (
  if exist "%%~fF" (
    echo [CONVERT] "%%~nxF" -> "%%~nF.jpg" >>"%LOG%"
    magick "%%~fF" "%DEST%\%%~nF.jpg"
    if errorlevel 1 (
      echo [ERROR] Failed to convert "%%~nxF" >>"%LOG%"
    ) else (
      echo [MOVE] "%%~nxF" -> "%DEST%" >>"%LOG%"
      move /Y "%%~fF" "%DEST%" >nul
    )
  )
)

REM --- Move JPG/JPEG (sanitize step placeholder) ---
for %%F in ("%SOURCE%\*.jpg") ("%SOURCE%\*.jpeg") do (
  if exist "%%~fF" (
    echo [SANITIZE] "%%~nxF" (placeholder) >>"%LOG%"
    REM Example sanitize ideas (uncomment if desired):
    REM magick "%%~fF" -auto-orient -strip "%DEST%\%%~nxF"
    REM if not errorlevel 1 del "%%~fF"
    REM else move instead of re-encoding:
    move /Y "%%~fF" "%DEST%" >nul
  )
)

REM Status heartbeat so you can see it’s alive
echo [HEARTBEAT] %time% watching... >>"%LOG%"
timeout /t 5 >nul
goto loop
