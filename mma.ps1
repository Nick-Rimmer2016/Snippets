# Load the YAML file containing the rules
$rules = Get-Content -Path "C:\Path\To\Rules.yaml" -Raw | ConvertFrom-Yaml

# Import the CSV file
$data = Import-Csv -Path "C:\Path\To\File.csv"

# Loop through each row in the CSV file
foreach ($row in $data) {
    # Check if the "Status" column contains the word "Running"
    if ($row.Status -like $rules[0].Condition) {
        # Apply the "Restart" action
        Write-Output "Restarting server $($row.ServerName)"
    }
    # Check if the "Status" column contains the word "Stopped"
    elseif ($row.Status -like $rules[1].Condition) {
        # Apply the "Start" action
        Write-Output "Starting server $($row.ServerName)"
    }
    # Check if the "ServerName" column contains the word "Server1"
    elseif ($row.ServerName -like $rules[2].Condition) {
        # Apply the "Notify Admin" action
        Write-Output "Notifying admin about server $($row.ServerName)"
    }
    # No rule matched
    else {
        Write-Output "No rule matched for server $($row.ServerName)"
    }
}


