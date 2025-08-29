import sys, os, csv, time

def fallback_csv(project_dir, infile):
    out_csv = os.path.join(project_dir, "Output", "ocr_results.csv")
    exists = os.path.exists(out_csv)
    row = {
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
        "file": os.path.basename(infile),
        "text": "(fallback) OCR not available; storing filename only"
    }
    with open(out_csv, "a", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["timestamp","file","text"])
        if not exists:
            w.writeheader()
        w.writerow(row)

def main():
    if len(sys.argv) < 3:
        print("Usage: ocr_pipeline.py <image_path> <project_dir>", flush=True)
        sys.exit(1)
    image_path = sys.argv[1]
    project_dir = sys.argv[2]

    # Try pytesseract; if not available, do a fallback CSV write
    try:
        from PIL import Image
        import pytesseract
        text = pytesseract.image_to_string(Image.open(image_path))
        out_csv = os.path.join(project_dir, "Output", "ocr_results.csv")
        exists = os.path.exists(out_csv)
        with open(out_csv, "a", newline="", encoding="utf-8") as f:
            import csv
            w = csv.DictWriter(f, fieldnames=["timestamp","file","text"])
            if not exists:
                w.writeheader()
            w.writerow({
                "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
                "file": os.path.basename(image_path),
                "text": text.strip()
            })
        sys.exit(0)
    except Exception as e:
        # Fallback record if PIL/pytesseract/tesseract isn't installed
        fallback_csv(project_dir, image_path)
        sys.exit(0)

if __name__ == "__main__":
    main()
