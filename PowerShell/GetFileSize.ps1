$csvPath = "C:\path\to\your\csvfile.csv"
$totalSize = 0

# Read the CSV file and process each line
$csvData = Import-Csv -Path $csvPath

foreach ($row in $csvData) {
    $filePath = $row.Filename
    if (Test-Path $filePath) {
        $fileInfo = Get-Item $filePath
        $totalSize += $fileInfo.Length
    } else {
        Write-Host "File not found: $filePath"
    }
}

# Convert total size to human-readable format
$totalSizeReadable = "{0:N2}" -f ($totalSize / 1MB) + " MB"

Write-Host "Total size of referenced files: $totalSizeReadable"
