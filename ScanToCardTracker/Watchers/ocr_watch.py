import os
import time
import csv
import logging
from pathlib import Path
from PIL import Image, UnidentifiedImageError
import pytesseract
import shutil

BASE = Path(r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker")
SCANS = BASE / "Scans"
INCOMING   = SCANS / "Incoming"
PROCESSING = SCANS / "Processing"
PROCESSED  = SCANS / "Processed"
ERROR_DIR  = SCANS / "Error"
OUTPUT_DIR = BASE / "Output"
CSV_PATH   = OUTPUT_DIR / "ocr_results.csv"
LOGS_DIR   = BASE / "Logs"
LOG_PATH   = LOGS_DIR / "ocr_watch.log"

for p in [INCOMING, PROCESSING, PROCESSED, ERROR_DIR, OUTPUT_DIR, LOGS_DIR]:
    p.mkdir(parents=True, exist_ok=True)

logging.basicConfig(
    filename=str(LOG_PATH),
    filemode="a",
    format="%(asctime)s [%(levelname)s] %(message)s",
    level=logging.INFO,
)
console = logging.StreamHandler()
console.setLevel(logging.INFO)
console.setFormatter(logging.Formatter("%(asctime)s [%(levelname)s] %(message)s"))
logging.getLogger().addHandler(console)

logging.info("OCR Watcher started. Watching: %s", INCOMING)

tess_try = [
    Path(r"C:\Program Files\Tesseract-OCR\tesseract.exe"),
    Path(r"C:\Program Files (x86)\Tesseract-OCR\tesseract.exe"),
]
for t in tess_try:
    if t.exists():
        pytesseract.pytesseract.tesseract_cmd = str(t)
        logging.info("Using Tesseract at: %s", t)
        break

VALID_EXTS = {".jpg", ".jpeg", ".png", ".JPG", ".JPEG", ".PNG"}

def process_image(image_path: Path) -> str:
    try:
        img = Image.open(image_path)
        text = pytesseract.image_to_string(img)
        return text.strip()
    except UnidentifiedImageError:
        return None

def append_to_csv(filename: str, text: str):
    with open(CSV_PATH, "a", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow([filename, text])

while True:
    for file in INCOMING.iterdir():
        if file.suffix in VALID_EXTS:
            dest = PROCESSING / file.name
            shutil.move(str(file), str(dest))
            logging.info("Processing: %s", dest)
            text = process_image(dest)
            if text is not None:
                append_to_csv(dest.name, text)
                shutil.move(str(dest), str(PROCESSED / dest.name))
                logging.info("Processed: %s", dest)
            else:
                shutil.move(str(dest), str(ERROR_DIR / dest.name))
                logging.error("Failed: %s", dest)
    time.sleep(5)
