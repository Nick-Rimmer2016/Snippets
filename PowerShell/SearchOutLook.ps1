# Create a new Outlook application
$outlook = New-Object -comobject Outlook.Application

# Get the Namespace and Logon
$namespace = $outlook.GetNameSpace("MAPI")

# Function to search emails recursively in all subfolders
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
                Write-Output "Body Preview: $($item.Body.Substring(0, [System.Math]::Min($item.Body.Length, 300)))"  # Display first 300 characters of the body
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

# Get the Inbox folder; assuming default store
$inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)

# Define your search keyword
$searchString = "YourSearchString"

# Start the recursive search
Search-Emails -Folder $inbox -SearchString $searchString
