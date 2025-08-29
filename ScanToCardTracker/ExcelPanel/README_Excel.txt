
Excel Panel (UF_CardTracker + modCardTracker)
=============================================

What's included
---------------
• UF_CardTracker.frm — the button panel (4 buttons)
• modCardTracker.bas — macros for Import/Output/Diagnostics
• README_Excel.txt — this file

How to install into your .xlsm (2 minutes)
------------------------------------------
1) Open your CardTracker workbook (.xlsm) in Excel.
2) Press Alt+F11 to open the VBA editor.
3) In the Project panel:
   - If you have older/broken versions: right‑click and Remove them.
4) Import both files:
   - Right‑click your project → Import File… → select UF_CardTracker.frm
   - Right‑click your project → Import File… → select modCardTracker.bas
5) Back in Excel:
   - Press Alt+F8 → run ShowPanel
   - Or add a button on any sheet that runs ShowPanel

Notes
-----
• The macros read PROJECT_DIR.env (written by Start_All_v6.bat) to find your folders.
• Import OCR & Map expects Output\ocr_results.csv (your OCR pipeline will create this; placeholder in scripts for now).
