@echo off
echo Checking Python installation...
python --version
echo Navigating to the Scripts folder...
cd /d C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts
echo Running the OCR Watch script...
python ocr_watch.py
echo Script finished running.
pause

