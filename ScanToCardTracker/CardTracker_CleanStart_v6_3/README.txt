CardTracker — Clean Start v6.3 (Minimized Windows)
================================================
This package sets up AutoMove + OCR watchers that start minimized and can auto-run on login.

Quick Start (2 minutes):
1) Extract this ZIP to: Desktop\CardTracker\ScanToCardTracker   (recommended path)
   You should end up with: C:\Users\YOURNAME\Desktop\CardTracker\ScanToCardTracker
2) Double‑click RUN_ME_FIRST.bat (creates folders, checks Python/Tesseract, primes CSV).
3) Double‑click start_all.bat — you should see two minimized black windows:
     • CardTracker - AutoMove Watcher (minimized)
     • CardTracker - OCR Watcher (minimized)
4) (Optional) Auto-start on login:
     • Double‑click install_startup.bat  → it drops a shortcut into your Startup folder.
     • To view that folder later, run open_startup_folder.bat

How it works:
• AutoMove watcher: Watches Scans\Incoming and moves new images to Scans\Processing.
• OCR watcher:     Processes any images in Scans\Processing via Python+pytesseract, appends text to Output\ocr_results.csv, then moves images to Scans\Processed (or Scans\Errors on failure).

Where to drop your images:
• Put card images in: Scans\Incoming
  (AutoMove will pick them up automatically.)

Logs & Output:
• Logs\automove_watch.log
• Logs\ocr_watch.log
• Output\ocr_results.csv

Edit paths?
• The scripts auto-detect common Desktop/OneDrive paths. If needed, open the .bat files and adjust the PROJECT_DIR override near the top.