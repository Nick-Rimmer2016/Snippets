# Create a new Outlook application
$outlook = New-Object -comobject Outlook.Application

# Get the Namespace and Logon
$namespace = $outlook.GetNameSpace("MAPI")

# Function to search emails in the specified folder and its subfolders
function Search-Emails {
    param (
        [Microsoft.Office.Interop.Outlook.MAPIFolder]$Folder,
        [string]$SearchString
    )

    # Process each item in the folder
    foreach ($item in $Folder.Items) {
        if ($item -is [Microsoft.Office.Interop.Outlook.MailItem]) {
            if ($item.Body -like "*$SearchString*" -or $item.Subject -like "*$SearchString*") {
                Write-Output "Subject: $($item.Subject)"
                Write-Output "Received: $($item.ReceivedTime)"
                Write-Output "Body Preview: $($item.Body.Substring(0, [System.Math]::Min($item.Body.Length, 300)))"
                Write-Output "Folder: $($Folder.FolderPath)"
                Write-Output "--------------------------------------------------------"
            }
        }
    }

    # Recursively search in each subfolder
    foreach ($subFolder in $Folder.Folders) {
        Search-Emails -Folder $subFolder -SearchString $SearchString
    }
}

# Function to find a folder by name starting from any folder
function Find-Folder {
    param (
        [Microsoft.Office.Interop.Outlook.MAPIFolder]$RootFolder,
        [string]$FolderName
    )

    # Check if the current folder is the one we're looking for
    if ($RootFolder.Name -eq $FolderName) {
        return $RootFolder
    }

    # Otherwise, search in each subfolder
    foreach ($subFolder in $RootFolder.Folders) {
        $found = Find-Folder -RootFolder $subFolder -FolderName $FolderName
        if ($found) {
            return $found
        }
    }

    return $null
}

# Prompt user for the folder name and search keyword
$folderName = Read-Host "Enter the folder name you want to search"
$searchString = Read-Host "Enter the search string"

# Start the search from the top-level (root) folder of the mailbox
$rootFolder = $namespace.Folders.Item(1)  # Assuming the first folder is the primary mailbox
$targetFolder = Find-Folder -RootFolder $rootFolder -FolderName $folderName

if ($targetFolder) {
    Search-Emails -Folder $targetFolder -SearchString $searchString
} else {
    Write-Output "Folder '$folderName' not found."
}
