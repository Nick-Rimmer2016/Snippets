# Define the service names to check
$serviceNames = @("wuauserv", "bits", "Spooler", "nonexistentservice")

# Get the list of servers from Active Directory
$servers = Get-ADComputer -Filter 'OperatingSystem -like "*server*"' | Select-Object -ExpandProperty Name

# Initialize an empty array to hold the report data
$reportData = @()

# Function to check if a server is online
function Test-ServerConnection {
    param (
        [string]$server
    )
    $ping = Test-Connection -ComputerName $server -Count 1 -Quiet
    return $ping
}

# Loop through each server
foreach ($server in $servers) {
    if (Test-ServerConnection -server $server) {
        foreach ($serviceName in $serviceNames) {
            try {
                $service = Get-Service -ComputerName $server -Name $serviceName -ErrorAction Stop
                $status = "Exists"
            } catch {
                $status = "Does not exist"
            }

            # Add the result to the report data
            $reportData += [PSCustomObject]@{
                ServerName  = $server
                ServiceName = $serviceName
                Status      = $status
            }
        }
    } else {
        # Add the result to the report data indicating the server is offline
        $reportData += [PSCustomObject]@{
            ServerName  = $server
            ServiceName = "N/A"
            Status      = "Server is offline"
        }
    }
}

# Convert the report data to CSV and export it
$reportData | Export-Csv -Path "C:\Path\To\Your\Report.csv" -NoTypeInformation

Write-Output "Report generated: C:\Path\To\Your\Report.csv"
