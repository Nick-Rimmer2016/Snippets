# Step 1: Parse the YAML file
$rules = Get-Content -Path "rules.yaml" -Raw | ConvertFrom-Yaml
$decisionRules = $rules.'decision engine'.rules
$decisionActions = $rules.'decision engine'.actions

# Step 2: Read the CSV file
$data = Import-Csv -Path "data.csv"

# Initialize an empty array to hold the results
$results = @()

# Step 3: Apply the rules to each row of data
foreach ($row in $data) {
    $matchingRuleFound = $false
    foreach ($rule in $decisionRules.GetEnumerator()) {
        $ruleValue = $rule.Value
        if ($row.Server -match $ruleValue) {
            $ruleAction = $decisionActions.("action$($rule.Name.Substring(4))")
            Write-Host $ruleAction
            # Or perform some action based on the rule here
            $matchingRuleFound = $true
            # Add a new object to the results array
            $results += [PSCustomObject] @{
                Rule = $rule.Name
                Match = $ruleValue
                Action = $ruleAction
                CVE = $row.CVE
                Version = $row.Version
                Fix = $row.Fix
                Date = $row.Date
                Server = $row.Server
                Tag = $row.Tag
            }
        }
    }
    if (!$matchingRuleFound) {
        Write-Host "No matching rule found for the following row:"
        Write-Host $row
        # Or write the row to a separate output file here
        # Add a new object to the results array
        $results += [PSCustomObject] @{
            Rule = "None"
            Match = "None"
            Action = "None"
            CVE = $row.CVE
            Version = $row.Version
            Fix = $row.Fix
            Date = $row.Date
            Server = $row.Server
            Tag = $row.Tag
        }
    }
}

# Step 4: Save the results
$results | Export-Csv -Path "results.csv" -NoTypeInformation
