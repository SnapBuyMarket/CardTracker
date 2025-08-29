CardTracker — Builder v1 (Hard‑Wired)
====================================

What this does
--------------
• Installs CardTracker to your Desktop (OneDrive Desktop if present), at:
  C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker
  or fallback:
  C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker

• Creates all folders (Scans/Incoming, Output, Logs, Scripts, etc.).
• Copies in ready-made watchers and a basic OCR script.
• Creates a Startup shortcut so watchers run automatically when you log in.
• Starts both watchers right away.

How to install (1 step)
-----------------------
1) Extract this ZIP anywhere (e.g., Desktop), then double‑click: RUN_BUILDER.bat

Where to drop images
--------------------
• From your phone: put images into OneDrive folder: C:\Users\cwall\OneDrive\aaaScanned Cards
  (Builder creates it if missing). AutoMove watcher will move them into Scans\Incoming automatically.
• Or test manually: drop a JPEG/PNG directly into:
  C:\Users\cwall\OneDrive\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming
  (or the non‑OneDrive fallback path).

Checking status
---------------
• Double‑click: Scripts\diag.bat
• Open the Startup folder quickly: Scripts\open_startup_folder.bat

Notes
-----
• OCR uses Python + pytesseract if available. If Python isn't found, files still flow through (blank OCR text is written) so your Excel panel can import the CSV.
• Excel panel files (UF_CardTracker.frm, modCardTracker.bas) are included under payload\ExcelPanel if you want to re‑import them later via Alt+F11 in Excel.
• All scripts are hard‑wired for user "cwall". If this PC uses a different username, tell me and I'll generate a new build.
