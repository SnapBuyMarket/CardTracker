# CardTracker Watchers (Fresh Install)

## What this bundle does
- **AutoMove**: moves images from your OneDrive `AAAScanned` folder into `Scans\Incoming`.
- **OCR Watcher**: reads images from `Incoming`, moves to `Processing`, runs OCR with Tesseract, writes text to `Output\ocr_results.csv`, then moves the image to `Processed`. Optionally it archives to `Scans\Scanned`.

## Install steps (one-time)
1) Extract this folder to: `C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker`
   - Make sure the resulting paths look like:
     - `C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts\*.py`
     - `C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming` (etc)
     - `C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Output\ocr_results.csv`

2) Install requirements if needed:
   - Python 3.x installed
   - Tesseract OCR installed (default: `C:\Program Files\Tesseract-OCR\`)
   - Python packages: `pip install pillow pytesseract`

3) (Optional) If your OneDrive source folder is different, open `Scripts\common_config.py` and edit `SOURCE_ONEDRIVE`.

## How to run
- Double-click: `C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scripts\start_all.bat`
  - It launches AutoMove and OCR Watcher in minimized windows.
- Or run them individually:
  - `auto_move.bat`
  - `ocr_watch.bat`

## Logs
- `Scripts\logs\auto_move_log.txt`
- `Scripts\logs\ocr_watch_log.txt`

## CSV Output
- `Output\ocr_results.csv` with columns:
  `timestamp,filename,source_path,ocr_text,status,notes`

## Notes
- Supported image types: .jpg/.jpeg/.png/.tif/.tiff/.bmp
- Unsupported/corrupted files go to `Scans\Error` with a note in CSV.
- To adjust archive behavior, edit in `Scripts\common_config.py`:
  - `ARCHIVE_TO_SCANNED = True/False`
  - `DELETE_AFTER_ARCHIVE = True/False` (use with caution)