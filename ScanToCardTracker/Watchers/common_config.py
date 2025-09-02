# common_config.py

# Directories for scanning and OCR processing
INCOMING_DIR = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
PROCESSING_DIR = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processing"
PROCESSED_DIR = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed"
ERROR_DIR = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Error"
SCANNED_DIR = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Scanned"  # Optional

# OCR output CSV file location
OCR_OUTPUT_CSV = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Output\ocr_results.csv"

# Log file location
LOG_FILE = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Logs\ocr_watch_log.txt"

# Tesseract path (adjust if installed somewhere else)
DEFAULT_TESSERACT = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

# Archive and deletion settings
ARCHIVE_TO_SCANNED = True  # Set to True if you want to archive images to Scanned
DELETE_AFTER_ARCHIVE = False  # Set to True to delete images after archiving
