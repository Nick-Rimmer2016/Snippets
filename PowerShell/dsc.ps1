# Define the list of servers
$servers = @("Server1", "Server2", "Server3")  # Replace with your server names or IP addresses

# Initialize an empty array to store the results
$results = @()

# Loop through each server and get the DSC Configuration status
foreach ($server in $servers) {
    $status = Invoke-Command -ComputerName $server -ScriptBlock { Test-DscConfiguration -Detailed } -ErrorAction SilentlyContinue
    if ($status) {
        $inDesiredState = $status.ResourcesInDesiredState -join ", "
        $notInDesiredState = $status.ResourcesNotInDesiredState -join ", "
        $results += [pscustomobject]@{
            Server = $server
            Status = if ($status.InDesiredState) { "In Desired State" } else { "Not in Desired State" }
            ResourcesInDesiredState = $inDesiredState
            ResourcesNotInDesiredState = $notInDesiredState
        }
    } else {
        $results += [pscustomobject]@{
            Server = $server
            Status = "Unavailable"
            ResourcesInDesiredState = "N/A"
            ResourcesNotInDesiredState = "N/A"
        }
    }
}

# Convert the results to HTML
$htmlContent = $results | ConvertTo-Html -Property Server, Status, ResourcesInDesiredState, ResourcesNotInDesiredState -Title "DSC Configuration Status for Multiple Servers" -PreContent "<h1>DSC Configuration Report</h1>"

# Add colorful CSS styling
$css = @"
<style>
    body {
        font-family: Arial, sans-serif;
    }
    table {
        border-collapse: collapse;
        width: 100%;
    }
    th {
        background-color: #4CAF50;
        color: white;
    }
    th, td {
        border: 1px solid black;
        padding: 8px;
        text-align: left;
    }
    td {
        background-color: #f2f2f2;
    }
    .status-desired {
        background-color: #d4edda;
        color: #155724;
    }
    .status-not-desired {
        background-color: #f8d7da;
        color: #721c24;
    }
    .status-unavailable {
        background-color: #ffeeba;
        color: #856404;
    }
    h1 {
        text-align: center;
    }
</style>
"@

# Add the CSS to the HTML content
$htmlContent = $css + $htmlContent

# Save the HTML content to a file
$outputPath = "C:\Reports\DSCConfigurationReport_MultipleServers.html"
$htmlContent | Out-File -FilePath $outputPath -Encoding UTF8

# Open the HTML report in the default web browser
Start-Process $outputPath
