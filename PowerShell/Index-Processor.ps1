# Define the function Process-Index
# Function to send email notification
# Read the indexes from the file
$indexes = Get-Content "C:\path\to\indexes.txt"

# Loop through each index and process it
foreach ($index in $indexes) {
    $success = Process-Index -filename $index
    if ($success) {
        Send-Email -index $index
    } else {
        Write-Host "Processing of $index failed"
    }
}
