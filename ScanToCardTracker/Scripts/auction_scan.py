import argparse, csv, os
from datetime import datetime

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--inventory", required=True, help="Path to CollX CSV (repo-relative in Actions)")
    p.add_argument("--out", required=True, help="Output CSV path")
    args = p.parse_args()

    in_path = args.inventory
    out_path = args.out

    os.makedirs(os.path.dirname(out_path), exist_ok=True)

    total_rows = 0
    header = None

    # Open input and output, copy ALL rows with a short summary header at the top
    with open(out_path, "w", newline="", encoding="utf-8") as fo:
        w = csv.writer(fo)

        # We’ll fill total_rows after copying
        run_ts = datetime.utcnow().isoformat() + "Z"
        w.writerow(["run_timestamp", run_ts])
        w.writerow(["source_csv", in_path])
        w.writerow(["note", "FULL_DUMP_OF_SOURCE_BELOW"])
        w.writerow([])

        try:
            with open(in_path, "r", newline="", encoding="utf-8", errors="ignore") as fi:
                reader = csv.reader(fi)
                for i, row in enumerate(reader):
                    if i == 0:
                        header = row
                        # Write a small marker to make it obvious this is the **real** CSV
                        w.writerow(["__BEGIN_SOURCE_DATA__"])
                        if header:
                            w.writerow(header)
                        continue
                    w.writerow(row)
                    total_rows += 1
        except FileNotFoundError:
            # If missing, write a graceful output
            w.writerow(["ERROR", f"CSV not found at {in_path}"])
            return

        # Add a trailing summary line
        w.writerow([])
        w.writerow(["__END_SOURCE_DATA__"])
        w.writerow(["total_rows_in_source", total_rows])

    print(f"Wrote FULL dump to {out_path} with {total_rows} data rows.")

if __name__ == "__main__":
    main()
