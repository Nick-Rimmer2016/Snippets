$zipFilePath = "path_to_your.zip"
$password = "your_password"
$fileToDelete = "file_to_delete.txt"

# Load the necessary assembly for ZIP archive handling
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Create a MemoryStream to store the contents of the ZIP file
$zipStream = [System.IO.File]::OpenRead($zipFilePath)

# Open the ZIP file using a ZipArchive with the password
$archive = [System.IO.Compression.ZipArchive]::new($zipStream, [System.IO.Compression.ZipArchiveMode]::Update, $false, [System.Text.Encoding]::UTF8, $password)

# Get the entry corresponding to the file to be deleted
$entryToDelete = $archive.GetEntry($fileToDelete)

# Delete the entry (file) from the archive
if ($entryToDelete -ne $null) {
    $entryToDelete.Delete()
    Write-Host "File '$fileToDelete' has been deleted from the ZIP archive."
} else {
    Write-Host "File '$fileToDelete' not found in the ZIP archive."
}

# Close the archive and stream
$archive.Dispose()
$zipStream.Close()
