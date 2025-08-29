
CardTracker Startup Kit
=======================

This adds shortcuts so your watchers auto-launch every time you sign in.

Files:
 - install_startup.bat      -> Creates Startup shortcuts for AutoMove and OCR
 - uninstall_startup.bat    -> Removes those shortcuts
 - open_startup_folder.bat  -> Opens your Startup folder

Assumed locations (edit install_startup.bat if different):
  PROJECT_DIR = C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker
  SCRIPTS_DIR = %PROJECT_DIR%\Scripts
    - automove_watch.bat  (required)
    - ocr_watch.bat       (optional; shortcut skipped if missing)

How to use:
 1) Double-click install_startup.bat
 2) Confirm it found automove_watch.bat (and ocr_watch.bat if present)
 3) It opens your Startup folder so you can see the new .lnk files
 4) Reboot to verify both watchers launch automatically

If you later change script paths, just run install_startup.bat again.
