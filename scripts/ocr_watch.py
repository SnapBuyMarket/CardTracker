import os
import time
import csv
import shutil
import logging
from datetime import datetime
from pathlib import Path

# Try importing common_config.py
try:
    import common_config as cfg
except Exception as e:
    print("ERROR: Could not import common_config.py. Make sure it is in the same folder.")
    raise

# Logging Setup
logging.basicConfig(filename=cfg.LOG_FILE, level=logging.DEBUG, format="%(asctime)s - %(levelname)s - %(message)s")
print("OCR Watcher started. Monitoring:", cfg.INCOMING_DIR)
logging.info("OCR Watcher started. Monitoring: %s", cfg.INCOMING_DIR)

# Tesseract Setup
try:
    import pytesseract
    if os.path.exists(cfg.DEFAULT_TESSERACT):
        pytesseract.pytesseract.tesseract_cmd = cfg.DEFAULT_TESSERACT
    else:
        logging.warning("Tesseract not found at %s", cfg.DEFAULT_TESSERACT)
except Exception as e:
    print("WARNING: pytesseract not available or Tesseract not found:", e)
    logging.warning("pytesseract not available or Tesseract path issue: %s", e)
    pytesseract = None

# Pillow (PIL) Setup
try:
    from PIL import Image, UnidentifiedImageError
except Exception as e:
    print("ERROR: Pillow (PIL) is not installed:", e)
    logging.exception("Pillow not installed")
    raise

# Supported image file extensions
SUPPORTED_EXTS = {".jpg", ".jpeg", ".png", ".tif", ".tiff", ".bmp"}

# Function to write OCR results to CSV
def write_csv_row(row):
    header = ["timestamp", "filename", "source_path", "ocr_text", "status", "notes"]
    must_write_header = not os.path.exists(cfg.OCR_OUTPUT_CSV) or os.path.getsize(cfg.OCR_OUTPUT_CSV) == 0
    with open(cfg.OCR_OUTPUT_CSV, "a", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        if must_write_header:
            w.writerow(header)
        w.writerow(row)

# Safe move function to handle file movement
def safe_move(src, dest_dir):
    os.makedirs(dest_dir, exist_ok=True)
    name = os.path.basename(src)
    target = os.path.join(dest_dir, name)
    if os.path.abspath(src) == os.path.abspath(target):
        return target
    if os.path.exists(target):
        stem = Path(name).stem
        ext = Path(name).suffix
        target = os.path.join(dest_dir, f"{stem}_{int(time.time())}{ext}")
    shutil.move(src, target)
    return target

# Function to process images with OCR
def process_image(img_path):
    ts = datetime.now().isoformat(timespec="seconds")
    fname = os.path.basename(img_path)
    try:
        # Open image
        with Image.open(img_path) as img:
            img.load()

        if pytesseract is None:
            raise RuntimeError("pytesseract/Tesseract not available")

        # Run OCR
        text = pytesseract.image_to_string(img)
        logging.debug("OCR OK for %s", img_path)

        # Write OCR results to CSV
        write_csv_row([ts, fname, img_path, text.strip(), "OK", ""])
        return text, None
    except UnidentifiedImageError:
        note = "Unsupported or corrupted image format"
        write_csv_row([ts, fname, img_path, "", "ERROR", note])
        logging.error("%s: %s", fname, note)
        return None, note
    except Exception as e:
        note = f"OCR error: {e}"
        write_csv_row([ts, fname, img_path, "", "ERROR", note])
        l
