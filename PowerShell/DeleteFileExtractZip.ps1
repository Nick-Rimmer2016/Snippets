Add-Type -AssemblyName System.IO.Compression.FileSystem

$zipFilePath = "path_to_your.zip"
$password = "your_password"
$fileToDelete = "file_to_delete.txt"

# Open the ZIP file with the password
$archive = [System.IO.Compression.ZipFile]::OpenRead($zipFilePath, [System.IO.Compression.ZipArchiveMode]::Update, [System.Text.Encoding]::UTF8, $password)

# Get the entry corresponding to the file to be deleted
$entryToDelete = $archive.GetEntry($fileToDelete)

# Delete the entry (file) from the archive
if ($entryToDelete -ne $null) {
    $entryToDelete.Delete()
    Write-Host "File '$fileToDelete' has been deleted from the ZIP archive."
} else {
    Write-Host "File '$fileToDelete' not found in the ZIP archive."
}

# Close the archive
$archive.Dispose()
