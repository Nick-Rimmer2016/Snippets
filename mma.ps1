# Import the CSV file
$servers = Import-Csv -Path "C:\Path\To\File.csv"

# Load the YAML file
$config = Get-Content -Path "C:\Path\To\Config.yaml" -Raw | ConvertFrom-Yaml

# Define the rule engine
$ruleEngine = @{
    "JK*" = $config.JKValue
    "Server2" = $config.Server2Value
    # Add more rules here as needed
}

# Apply the rule engine to extract lines from the CSV file
$filteredServers = $servers | Where-Object { $ruleEngine.ContainsKey($_.ServerName) }

# Output the filtered servers
$filteredServers

