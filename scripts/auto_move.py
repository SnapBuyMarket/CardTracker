import os
import time
import shutil
import logging
from datetime import datetime
from pathlib import Path
import sys

try:
    import common_config as cfg
except Exception as e:
    print("ERROR: Could not import common_config.py. Make sure it is in the same folder.")
    raise

LOG_PATH = os.path.join(cfg.LOG_DIR, "auto_move_log.txt")
logging.basicConfig(filename=LOG_PATH, level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
print("AutoMove started. Watching:", cfg.SOURCE_ONEDRIVE)
logging.info("AutoMove started. Watching: %s", cfg.SOURCE_ONEDRIVE)

SUPPORTED_EXTS = {".jpg", ".jpeg", ".png", ".tif", ".tiff", ".bmp"}

def is_image_file(path: str) -> bool:
    return Path(path).suffix.lower() in SUPPORTED_EXTS

def move_new_files():
    try:
        for name in os.listdir(cfg.SOURCE_ONEDRIVE):
            src = os.path.join(cfg.SOURCE_ONEDRIVE, name)
            if not os.path.isfile(src):
                continue
            if not is_image_file(src):
                continue
            dest = os.path.join(cfg.INCOMING_DIR, name)
            # If file with same name exists, add timestamp suffix
            if os.path.exists(dest):
                stem = Path(name).stem
                ext = Path(name).suffix
                stamped = f"{stem}_{int(time.time())}{ext}"
                dest = os.path.join(cfg.INCOMING_DIR, stamped)
            try:
                shutil.move(src, dest)
                print(f"Moved {src} -> {dest}")
                logging.info("Moved %s -> %s", src, dest)
            except Exception as e:
                print(f"ERROR moving {src} -> {dest}: {e}")
                logging.error("ERROR moving %s -> %s: %s", src, dest, e)
    except FileNotFoundError:
        msg = f"Source folder not found: {cfg.SOURCE_ONEDRIVE}"
        print("WARNING:", msg)
        logging.warning(msg)
    except Exception as e:
        print("Unexpected error:", e)
        logging.exception("Unexpected error in move_new_files")

if __name__ == "__main__":
    # Poll every 6 seconds
    while True:
        move_new_files()
        time.sleep(6)