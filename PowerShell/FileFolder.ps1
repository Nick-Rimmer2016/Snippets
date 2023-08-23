$folderPath = "C:\TEST"

# Get the list of second-level folders in the folder
$secondLevelFolders = Get-ChildItem -Path $folderPath -Directory | Get-ChildItem -Directory

# Iterate through second-level folders and calculate file count and size
$output = @()
foreach ($folder in $secondLevelFolders) {
    $fileList = Get-ChildItem -Path $folder.FullName -File
    $fileCount = $fileList.Count
    $totalSize = ($fileList | Measure-Object -Property Length -Sum).Sum / 1GB

    $outputLine = @{
        FolderPath = $folder.FullName
        FileCount = $fileCount
        TotalSize = $totalSize
    }

    $output += New-Object PSObject -Property $outputLine
}

# Display the output as a table
$output | Format-Table -AutoSize
