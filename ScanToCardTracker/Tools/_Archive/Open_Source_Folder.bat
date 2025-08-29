
@echo off
setlocal ENABLEDELAYEDEXPANSION
title CardTracker — Open Detected Source Folder

rem Rebuild detection list (same logic as v6.3 automove)
set SOURCES_TXT=%TEMP%\ct_sources_open_%RANDOM%.txt
if exist "%SOURCES_TXT%" del "%SOURCES_TXT%" >nul 2>&1

for /d %%R in ("%USERPROFILE%\OneDrive*") do (
  for /f "usebackq delims=" %%P in (`dir "%%~R\aaaScanned Cards" /ad /b /s 2^>nul`) do (
     echo %%~P>>"%SOURCES_TXT%"
  )
)

set FIRST=
for /f "usebackq delims=" %%L in ("%SOURCES_TXT%") do (
  if not defined FIRST set FIRST=%%~L
)

if not defined FIRST (
  echo No 'aaaScanned Cards' folder detected under %USERPROFILE%\OneDrive*.
  echo Try creating the folder inside your OneDrive and drop a test image there.
  pause
  exit /b 1
)

echo Opening: %FIRST%
explorer "%FIRST%"
