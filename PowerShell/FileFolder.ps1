$folderPath = "C:\TEST"

# Get the list of files and folders in the folder (including subfolders)
$itemList = Get-ChildItem -Path $folderPath -File -Recurse

# Calculate the number of files, folders, and total size
$fileCount = ($itemList | Where-Object { $_.PSIsContainer -eq $false }).Count
$folderCount = ($itemList | Where-Object { $_.PSIsContainer -eq $true }).Count
$totalSize = ($itemList | Measure-Object -Property Length -Sum).Sum / 1GB

# Format the output as a table
$output = "$folderPath".PadRight(30) + ("{0:N0} files" -f $fileCount).PadRight(20) + ("{0:N0} folders" -f $folderCount).PadRight(20) + ("{0:N2} GB" -f $totalSize)

# Display the formatted output
Write-Host $output
