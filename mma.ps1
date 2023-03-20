$workspaceId = "<Workspace ID>"
$proxyServer = "<Proxy Server>"

# Download the MMA setup file
$mmaDownloadUrl = "https://download.microsoft.com/download/9/1/D/91D3B4B4-4E1D-4DD4-971D-2978B965B154/MicrosoftMonitoringAgent.msi"
$mmaInstaller = "MicrosoftMonitoringAgent.msi"
Invoke-WebRequest -Uri $mmaDownloadUrl -OutFile $mmaInstaller

# Install the MMA agent
$arguments = "/i $mmaInstaller /qn ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_ID=$workspaceId OPINSIGHTS_WORKSPACE_KEY=$workspaceKey"
if ($proxyServer -ne "") {
    $arguments += " UseProxy=1 ProxyHostName=$proxyServer"
}

Start-Process "msiexec" -ArgumentList $arguments -Wait

# Clean up the setup file
Remove-Item $mmaInstaller
