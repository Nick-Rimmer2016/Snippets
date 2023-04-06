# Step 1: Parse the YAML file
$rules = Get-Content -Path "rules.yaml" -Raw | ConvertFrom-Yaml

# Step 2: Read the CSV file
$data = Import-Csv -Path "data.csv"

# Step 3: Apply the rules to each row of data
foreach ($row in $data) {
    # Convert the row to a string for searching
    $rowString = $row | Out-String
    if ($rowString.Contains($rules.condition)) {
        Write-Host $rules.action
        # Or perform some action based on the rule here
    }
}

# Step 4: Save the results
$data | Export-Csv -Path "results.csv" -NoTypeInformation
