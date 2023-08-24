# Define the value to search for
$targetValue = "your_target_value_here"

# Specify the folder path where the text files are located
$folderPath = "C:\path\to\your\text\files"

# Get a list of text files in the folder
$textFiles = Get-ChildItem -Path $folderPath -Filter "*.txt"

# Loop through each text file
foreach ($file in $textFiles) {
    # Read the content of the text file
    $content = Get-Content -Path $file.FullName -Raw

    # Check if the target value is present in the content
    if ($content -match $targetValue) {
        Write-Host "Value found in $($file.Name): Doc OK"
    } else {
        Write-Host "Value not found in $($file.Name): Initiating investigation"
        # You can add further investigation steps or actions here
    }
}
