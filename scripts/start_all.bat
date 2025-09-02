@echo off
setlocal

REM Base dir (edit if you placed the folder elsewhere)
set "BASE=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
set "SCRIPTS=%BASE%\Scripts"

pushd "%SCRIPTS%"
start "AutoMove" /min "%SCRIPTS%\auto_move.bat"
start "OCR Watcher" /min "%SCRIPTS%\ocr_watch.bat"
popd

echo Started AutoMove and OCR Watcher in minimized windows.
exit /b 0