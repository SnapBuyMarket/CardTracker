
Card Tracker v2 — One-zip, open-and-go
======================================
- Buttons auto-added to BOTH Search and Dashboard by the installer.
- Config keys match your sheet: eBay_AppID, eBay_DevID, eBay_CertID, eBay_UserToken, eBay_RuName.
- New Contacts sheet for your 30k Whatnot friends (with export-ready columns).
- Templates/invite.html: starter email for upcoming shows.

Quick Start
-----------
1) Open CardTracker.xlsx → Config; paste your IDs (App/Dev/Cert) and UserToken. (RuName is optional.)
2) Close Excel.
3) Double-click Installer\ImportVBA.vbs
   - Imports macros, saves CardTracker.xlsm, reopens it, adds buttons on Search + Dashboard, saves.
4) Open CardTracker.xlsm and click “Last 7 Days” (Search or Dashboard).

Notes
-----
- If no auctions found at $25 cap, it auto-tries $50 then $100 (set in Config).
- Hourly refresh runs while file is open if HOURLY_REFRESH=TRUE.
- Contacts: paste your list, keep Opt_In=Y to avoid emailing people who didn’t consent.

Troubleshooting
---------------
- Enable macros & “Trust access to the VBA project object model” for the installer.
- If VBScript is blocked, import .bas manually (ALT+F11) and run Module_UI.AddButtons once.
