# Define the list of servers
$servers = @("Server1", "Server2", "Server3")  # Replace with your server names or IP addresses

# Initialize an empty array to store the results
$results = @()

# Loop through each server and get the DSC Configuration status
foreach ($server in $servers) {
    $status = Invoke-Command -ComputerName $server -ScriptBlock { Test-DscConfiguration } -ErrorAction SilentlyContinue
    if ($status) {
        $results += [pscustomobject]@{
            Server = $server
            Status = $status.Status
            InDesiredState = $status.InDesiredState
            ResourcesNotInDesiredState = $status.ResourcesNotInDesiredState
        }
    } else {
        $results += [pscustomobject]@{
            Server = $server
            Status = "Unavailable"
            InDesiredState = $null
            ResourcesNotInDesiredState = $null
        }
    }
}

# Convert the results to HTML
$htmlContent = $results | ConvertTo-Html -Property Server, Status, InDesiredState, ResourcesNotInDesiredState -Title "DSC Configuration Status for Multiple Servers" -PreContent "<h1>DSC Configuration Report</h1>"

# Add some CSS styling for better presentation
$css = @"
<style>
    body {
        font-family: Arial, sans-serif;
    }
    table {
        border-collapse: collapse;
        width: 100%;
    }
    table, th, td {
        border: 1px solid black;
    }
    th, td {
        padding: 8px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
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
