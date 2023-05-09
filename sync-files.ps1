$sourcePath = "\\source\share\path"
$destinationPath = "\\destination\share\path"
$logPath = "C:\SyncLogs"

if (!(Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

$logFileName = "SyncLog_" + (Get-Date).ToString("yyyyMMdd") + ".log"
$logFile = Join-Path -Path $logPath -ChildPath $logFileName

$filesToSync = Get-ChildItem $sourcePath -Recurse | Where-Object {!($_.PSIsContainer)}

$filesCopied = @()

foreach ($file in $filesToSync) {
    $destinationFile = $file.FullName.Replace($sourcePath, $destinationPath)

    if (!(Test-Path $destinationFile)) {
        Write-Host "Copying $($file.FullName) to $($destinationFile)..."
        Copy-Item $file.FullName -Destination $destinationFile
        $filesCopied += "$($file.FullName) copied to $($destinationFile)"
    }
    else {
        if ($file.LastWriteTime -gt (Get-Item $destinationFile).LastWriteTime) {
            Write-Host "Updating $($destinationFile) with $($file.FullName)..."
            Copy-Item $file.FullName -Destination $destinationFile -Force
            $filesCopied += "$($file.FullName) updated in $($destinationFile)"
        }
    }
}

if ($filesCopied.Count -gt 0) {
    $logEntry = "Files copied/updated:`r`n" + ($filesCopied -join "`r`n") + "`r`n"
    Add-Content -Path $logFile -Value $logEntry
}
