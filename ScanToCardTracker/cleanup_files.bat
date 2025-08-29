@echo off
setlocal ENABLEDELAYEDEXPANSION

rem --- Define Directories ---
set "INCOMING_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
set "PROCESSED_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed"
set "ARCHIVE_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed_Archive"

rem --- Set Cleanup Time Limit (e.g., 7 days) ---
set "CLEANUP_DAYS=7"
set "CURRENT_DATE=%DATE%"
set "CURRENT_TIMESTAMP=%TIME%"

rem --- Delete or Archive Old Files in Incoming ---
echo [INFO] Cleaning up old files in Incoming...
forfiles /p "%INCOMING_DIR%" /m *.* /d -%CLEANUP_DAYS% /c "cmd /c del @path"
echo [INFO] Cleaned old files in Incoming.

rem --- Archive Processed Files that are older than CLEANUP_DAYS ---
echo [INFO] Archiving old files in Processed...
forfiles /p "%PROCESSED_DIR%" /m *.* /d -%CLEANUP_DAYS% /c "cmd /c move @path %ARCHIVE_DIR%"
echo [INFO] Archived old files from Processed.

rem --- Clean up the Archive Directory (optional, older than 30 days) ---
echo [INFO] Cleaning up old archived files older than 30 days...
forfiles /p "%ARCHIVE_DIR%" /m *.* /d -30 /c "cmd /c del @path"
echo [INFO] Cleaned old archived files.

pause
exit /b 0
