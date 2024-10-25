# Create an array to store combined results
$combinedResults = @()

foreach ($item1 in $csv1) {
    # Find matching item in the second CSV based on accounts and account_id
    $matchingItem = $csv2 | Where-Object { $_.account_id -eq $item1.accounts }

    # If there's a match, combine the fields from both items
    if ($matchingItem) {
        # Create a new object with fields from both CSVs
        $combinedObject = New-Object PSObject -Property ($item1 | Select-Object *).PSObject.Properties

        # Add fields from the matching item in csv2
        foreach ($property in $matchingItem.PSObject.Properties) {
            if (-not $combinedObject.PSObject.Properties.Match($property.Name)) {
                $combinedObject | Add-Member -MemberType NoteProperty -Name $property.Name -Value $property.Value
            }
        }

        # Add combined object to results
        $combinedResults += $combinedObject
    }
}

# Display the combined results
$combinedResults | Format-Table -AutoSize
