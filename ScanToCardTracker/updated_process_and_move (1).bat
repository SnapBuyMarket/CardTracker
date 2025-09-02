@echo off
for %%f in (C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processing\*.jpg) do (
    tesseract "%%f" "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Output\output_%%~nf.txt"
    move "%%f" "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed\"
)
