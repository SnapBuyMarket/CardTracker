import sys, csv, os
from PIL import Image
import pytesseract

def main():
    if len(sys.argv) < 3:
        print("[ERR] Usage: ocr_process.py <image_path> <output_csv>", file=sys.stderr)
        sys.exit(1)

    img_path = sys.argv[1]
    out_csv = sys.argv[2]

    if not os.path.exists(img_path):
        print(f"[ERR] Missing image: {img_path}", file=sys.stderr)
        sys.exit(1)

    # Try to be tolerant of Tesseract location
    # If tesseract isn't on PATH, fall back to default Windows install path
    if not pytesseract.get_tesseract_version():
        default = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
        if os.path.exists(default):
            pytesseract.pytesseract.tesseract_cmd = default

    try:
        text = pytesseract.image_to_string(Image.open(img_path))
        text = text.replace("\r", " ").replace("\n", " ").strip()
    except Exception as e:
        print(f"[ERR] OCR failed for {img_path}: {e}", file=sys.stderr)
        sys.exit(2)

    # Append to CSV
    need_header = not os.path.exists(out_csv) or os.path.getsize(out_csv) == 0
    with open(out_csv, "a", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        if need_header:
            w.writerow(["filename", "ocr_text"])
        w.writerow([os.path.basename(img_path), text])

    print(f"[OK] {os.path.basename(img_path)}")
    sys.exit(0)

if __name__ == "__main__":
    main()