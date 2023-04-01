# Import the powershell-yaml module
Import-Module powershell-yaml

# Load the YAML content from the file
$yamlContent = Get-Content -Path "servers_ports.yaml" -Raw
$serversData = ConvertFrom-Yaml -Yaml $yamlContent

# Function to test remote port connectivity
function Test-RemotePort ($host, $port, $protocol) {
    $result = Test-NetConnection -ComputerName $host -Port $port
    if ($result.TcpTestSucceeded) {
        Write-Host "$protocol ($port) is open on $host" -ForegroundColor Green
    } else {
        Write-Host "$protocol ($port) is closed on $host" -ForegroundColor Red
    }
}

# Get the local hostname
$localHostName = [System.Net.Dns]::GetHostName()

# Filter the servers data based on the local hostname
$serversData.servers = $serversData.servers | Where-Object { $_.server -eq $localHostName }

# Check if the local hostname is in the YAML file
if ($serversData.servers -eq $null) {
    Write-Host "The local hostname '$localHostName' is not found in the YAML file. No ports will be tested." -ForegroundColor Yellow
    exit
}

# Iterate through the YAML data and test each server and port
foreach ($serverData in $serversData.servers) {
    $remoteHost = $serverData.server
    foreach ($protocol in $serverData.ports.Keys) {
        $port = $serverData.ports[$protocol]
        Test-RemotePort -host $remoteHost -port $port -protocol $protocol
    }
}
