name: CollX Inventory & Auction Scan

on:
  workflow_dispatch:
    inputs:
      collx_csv:
        description: "Path to CollX CSV (relative to repo root)"
        required: false
        default: "ScanToCardTracker/ExcelPanel/download_Chriswallace-2025-09-01-214652.csv"

jobs:
  build-run:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install deps (if any)
        run: |
          python -m pip install --upgrade pip
          if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

      - name: Run scanner (tolerant if CSV missing)
        run: |
          CSV="${{ github.event.inputs.collx_csv }}"
      import argparse, csv, os, sys
from datetime import datetime

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--inventory", required=True, help="Path to CollX CSV (repo-relative when running in Actions)")
    p.add_argument("--out", required=True, help="Output CSV path")
    args = p.parse_args()

    in_path = args.inventory
    out_path = args.out

    # Make sure output directory exists
    os.makedirs(os.path.dirname(out_path), exist_ok=True)

    # Read input CSV (robust to different encodings/newlines)
    total_rows = 0
    header = None
    sample_rows = []

    try:
        with open(in_path, "r", newline="", encoding="utf-8", errors="ignore") as f:
            reader = csv.reader(f)
            for i, row in enumerate(reader):
                if i == 0:
                    header = row
                    continue
                total_rows += 1
                # Capture up to 200 rows as a quick “preview”
                if len(sample_rows) < 200:
                    sample_rows.append(row)
    except FileNotFoundError:
        # If somehow missing, write a graceful output
        with open(out_path, "w", newline="", encoding="utf-8") as fo:
            w = csv.writer(fo)
            w.writerow(["timestamp","notes"])
            w.writerow([datetime.utcnow().isoformat()+"Z", f"CSV not found at {in_path}"])
        print(f"Input CSV not found at {in_path}. Wrote a graceful placeholder to {out_path}.")
        sys.exit(0)

    # Write a simple, real output with summary + sample
    with open(out_path, "w", newline="", encoding="utf-8") as fo:
        w = csv.writer(fo)
        # Summary section
        w.writerow(["run_timestamp", datetime.utcnow().isoformat()+"Z"])
        w.writerow(["source_csv", in_path])
        w.writerow(["total_rows_in_source", total_rows])
        w.writerow([])

        # Sample section
        w.writerow(["SAMPLE_FIRST_200_ROWS"])
        if header:
            w.writerow(header)
        for r in sample_rows:
            w.writerow(r)

    print(f"Wrote output to {out_path} with {total_rows} total rows counted and {len(sample_rows)} sample rows.")

if __name__ == "__main__":
    main()

