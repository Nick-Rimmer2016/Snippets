# Define the log directory, date range, and the search term
$logDirectory = "C:\inetpub\logs\LogFiles"
$startDate = Get-Date "2023-12-01 00:00:00" # Change to your start date
$endDate = Get-Date "2023-12-05 23:59:59"   # Change to your end date
$errorPattern = "500" # Internal Server Error code

# Get files within the date range
$files = Get-ChildItem -Path $logDirectory -Recurse |
    Where-Object { 
        $_.LastWriteTime -ge $startDate -and $_.LastWriteTime -le $endDate 
    }

# Search for "Internal 500" in the filtered files
$results = foreach ($file in $files) {
    Select-String -Path $file.FullName -Pattern $errorPattern |
    Where-Object { $_.Line -match "500" } # Adjust further for more specific matches
}

# Output results
if ($results) {
    $results | Select-Object Path, LineNumber, Line
} else {
    Write-Host "No internal 500 errors found in the specified date range."
}
