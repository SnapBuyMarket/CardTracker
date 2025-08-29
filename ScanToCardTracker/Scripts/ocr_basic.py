# Basic OCR pipeline using pytesseract.
import sys, os, csv
try:
    from PIL import Image
    import pytesseract
except Exception as e:
    sys.stderr.write(f"[ocr_basic] Missing deps: {e}\n")
    sys.exit(2)

if len(sys.argv) < 3:
    sys.stderr.write("[ocr_basic] Expected 2 args: PROJECT_DIR filename\n")
    sys.exit(2)

project_dir = sys.argv[1]
filename = sys.argv[2]
proc_path = os.path.join(project_dir, "Scans", "Processing", filename)
out_csv = os.path.join(project_dir, "Output", "ocr_results.csv")
os.makedirs(os.path.dirname(out_csv), exist_ok=True)
if not os.path.exists(out_csv):
    with open(out_csv, "w", newline="", encoding="utf-8") as f:
        f.write("filename,ocr_text\n")

try:
    img = Image.open(proc_path)
    text = pytesseract.image_to_string(img, lang="eng")
    text = text.replace("\r", " ").replace("\n", " ").replace(",", " ").strip()
except Exception as e:
    sys.stderr.write(f"[ocr_basic] OCR failed for {filename}: {e}\n")
    sys.exit(3)

with open(out_csv, "a", newline="", encoding="utf-8") as f:
    w = csv.writer(f); w.writerow([filename, text])
print(f"[ocr_basic] OK: {filename}")
sys.exit(0)
