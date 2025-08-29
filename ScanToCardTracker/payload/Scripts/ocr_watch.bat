@echo off
setlocal ENABLEDELAYEDEXPANSION
set "PROJECT_DIR=C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

set "IN=%PROJECT_DIR%\Scans\Incoming"
set "PROC=%PROJECT_DIR%\Scans\Processing"
set "OUT=%PROJECT_DIR%\Scans\Processed"
set "LOG=%PROJECT_DIR%\Logs\ocr_watch.log"
set "PY=python"

for %%D in ("%IN%" "%PROC%" "%OUT%" "%PROJECT_DIR%\Output" "%PROJECT_DIR%\Logs") do if not exist "%%~D" mkdir "%%~D"
if not exist "%PROJECT_DIR%\Output\ocr_results.csv" echo filename,ocr_text>"%PROJECT_DIR%\Output\ocr_results.csv"

echo [OCR %DATE% %TIME%] Started (HARDWIRED) >> "%LOG%"

:loop
for %%F in ("%IN%\*.*") do (
    set "FN=%%~nxF"
    echo [OCR %DATE% %TIME%] Processing: !FN! >> "%LOG%"
    move "%%~fF" "%PROC%" >> "%LOG%" 2>&1

    where %PY% >nul 2>&1
    if !errorlevel! EQU 0 (
        if exist "%PROJECT_DIR%\Scripts\ocr_basic.py" (
            %PY% "%PROJECT_DIR%\Scripts\ocr_basic.py" "%PROJECT_DIR%" "!FN!" >> "%LOG%" 2>&1
            if !errorlevel! NEQ 0 (
                powershell -NoProfile -Command "Add-Content -Path '%PROJECT_DIR%\Output\ocr_results.csv' -Value ('0,' -f '!FN!')" 
            )
        ) else (
            powershell -NoProfile -Command "Add-Content -Path '%PROJECT_DIR%\Output\ocr_results.csv' -Value ('0,' -f '!FN!')" 
        )
    ) else (
        powershell -NoProfile -Command "Add-Content -Path '%PROJECT_DIR%\Output\ocr_results.csv' -Value ('0,' -f '!FN!')" 
    )

    move "%PROC%\!FN!" "%OUT%" >> "%LOG%" 2>&1
)
timeout /t 3 >nul
goto loop
