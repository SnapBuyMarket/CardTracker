param(
  [string]$TargetPath,
  [string]$ShortcutPath,
  [string]$Arguments = "",
  [string]$WorkingDirectory = ""
)

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $TargetPath
if ($Arguments) { $Shortcut.Arguments = $Arguments }
if ($WorkingDirectory) { $Shortcut.WorkingDirectory = $WorkingDirectory }
$Shortcut.WindowStyle = 7   # 7 = Minimized
$Shortcut.IconLocation = "$TargetPath,0"
$Shortcut.Save()