$sourcePath = "\\source\share\path"
$destinationPath = "\\destination\share\path"

$filesToSync = Get-ChildItem $sourcePath -Recurse | Where-Object {!($_.PSIsContainer)}

foreach ($file in $filesToSync) {
    $destinationFile = $file.FullName.Replace($sourcePath, $destinationPath)

    if (!(Test-Path $destinationFile)) {
        Write-Host "Copying $($file.FullName) to $($destinationFile)..."
        Copy-Item $file.FullName -Destination $destinationFile
    }
    else {
        if ($file.LastWriteTime -gt (Get-Item $destinationFile).LastWriteTime) {
            Write-Host "Updating $($destinationFile) with $($file.FullName)..."
            Copy-Item $file.FullName -Destination $destinationFile -Force
        }
    }
}
