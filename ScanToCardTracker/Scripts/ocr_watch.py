import os
import time
import csv
import shutil
import logging
from datetime import datetime
from PIL import Image, UnidentifiedImageError
import pytesseract

# --- CONFIG ---
incoming_dir   = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
processing_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processing"
processed_dir  = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed"
error_dir      = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Error"
ocr_output     = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Output\ocr_results.csv"

# If tesseract isn't on PATH, force it here:
# Adjust if you installed elsewhere
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

# --- LOGGING ---
log_path = os.path.join(os.path.dirname(__file__), "ocr_watch_log.txt")
logging.basicConfig(
    filename=log_path,
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logging.getLogger().addHandler(logging.StreamHandler())  # also print to console
logging.info("OCR Watcher started")

# --- UTILITIES ---
def ensure_dirs():
    for d in [incoming_dir, processing_dir, processed_dir, error_dir, os.path.dirname(ocr_output)]:
        os.makedirs(d, exist_ok=True)

def safe_move(src, dest_dir):
    try:
        os.makedirs(dest_dir, exist_ok=True)
        dest_path = os.path.join(dest_dir, os.path.basename(src))
        shutil.move(src, dest_path)
        logging.info(f"Moved to {dest_path}")
        return dest_path
    except Exception as e:
        logging.exception(f"Error moving {src} -> {dest_dir}: {e}")
        return None

def append_csv(row):
    header = ["timestamp","filename","text"]
    write_header = not os.path.exists(ocr_output)
    try:
        with open(ocr_output, "a", newline="", encoding="utf-8") as f:
            w = csv.writer(f)
            if write_header:
                w.writerow(header)
            w.writerow(row)
    except Exception as e:
        logging.exception(f"Error writing CSV: {e}")

def process_image(image_path):
    try:
        with Image.open(image_path) as img:
            text = pytesseract.image_to_string(img)
        return text
    except UnidentifiedImageError:
        raise RuntimeError("Unsupported image format/type")
    except Exception as e:
        raise RuntimeError(str(e))

# --- MAIN LOOP ---
def main():
    ensure_dirs()
    logging.info("Watching for new images in Incoming ...")
    exts = (".jpg",".jpeg",".png",".tif",".tiff",".bmp")  # allow upper/lower via lower()

    while True:
        try:
            for name in os.listdir(incoming_dir):
                src_path = os.path.join(incoming_dir, name)
                if not os.path.isfile(src_path):
                    continue
                if not name.lower().endswith(exts):
                    continue

                logging.info(f"Found image: {name}")

                # Move to Processing first
                proc_path = safe_move(src_path, processing_dir)
                if not proc_path:
                    continue  # move failed; already logged

                try:
                    text = process_image(proc_path)
                    append_csv([datetime.now().isoformat(timespec="seconds"), os.path.basename(proc_path), text.strip()])
                    # Move to Processed
                    done_path = safe_move(proc_path, processed_dir)
                    if not done_path:
                        # if failed to move to processed, try pushing to error
                        safe_move(proc_path, error_dir)
                except Exception as e:
                    logging.exception(f"OCR failed for {proc_path}: {e}")
                    safe_move(proc_path, error_dir)

        except Exception as loop_err:
            logging.exception(f"Watcher loop error: {loop_err}")

        time.sleep(2)  # small idle

if __name__ == "__main__":
    main()
