
CardTracker Scripts Cleanup Kit
===============================

This safely tidies your Scripts/ folder by moving non-essential files
into Scripts\_Archive (no deletions). A log is written so you can see
exactly what moved.

Keep list (left in Scripts\):
 - automove_watch.bat
 - ocr_watch.bat
 - start_all.bat
 - start_all_diag.bat
 - install_startup.bat
 - open_startup_folder.bat
 - kickstart_push_now.bat
 - kickstart_to_processing.bat
 - ocr_basic.py
 - ocr_pipeline.py
 - ocr_process.py
 - README.txt

Everything else gets moved to Scripts\_Archive.

Files:
 - scripts_cleanup.bat   -> Run this to tidy the folder
 - restore_from_archive.bat -> Restores ALL files from _Archive back to Scripts
 - README.txt

If you want to keep more files in Scripts permanently, edit the KEEP= line
near the top of scripts_cleanup.bat and add ;YourFileName.ext; to the list.
