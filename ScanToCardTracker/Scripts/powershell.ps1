# PowerShell script to fix read-only folder and permission issues

$folders = @(
    "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming",
    "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed",
    "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processing",
    "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Scanned",
    "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Error"
)

# Ensure full control and remove read-only from each folder and subfolder
foreach ($folder in $folders) {
    Write-Host "Fixing folder: $folder"
    
    # Set permissions to Full Control for the current user
    $acl = Get-Acl $folder
    $permission = "$env:UserDomain\$env:UserName", "FullControl", "Allow"
    $acl.SetAccessRuleProtection($true, $false)  # Disables inheritance
    $acl.AddAccessRule($permission)
    Set-Acl $folder $acl

    # Remove read-only attribute from all files
    Get-ChildItem -Recurse -Path $folder | ForEach-Object { 
        $_.IsReadOnly = $false
    }
    
    # Apply full control for all files and subfolders
    icacls $folder /grant:r "$env:UserDomain\$env:UserName:(OI)(CI)F" /T
}

Write-Host "Fix completed for all specified folders."
