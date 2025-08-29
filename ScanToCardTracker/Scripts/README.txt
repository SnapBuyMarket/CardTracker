
CardTracker Kickstart Kit
=========================

Use these if files are sitting in OneDrive or Incoming and you want to force them through *once* right now.

1) kickstart_push_now.bat
   - Moves JPG/JPEG/PNG from:
       C:\Users\cwall\OneDrive\aaaScanned Cards
     to:
       C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming
   - Size-stability check to avoid moving partially copied files.

2) kickstart_to_processing.bat
   - If your OCR watcher expects files in "Processing", this script moves
     any images from "Incoming" to "Processing" one time.

Logs:
  - %PROJECT_DIR%\Logs\kickstart.log

Recommended flow:
  A) Run kickstart_push_now.bat
  B) Watch your watchers. If OCR doesn't react from Incoming, then run kickstart_to_processing.bat.
