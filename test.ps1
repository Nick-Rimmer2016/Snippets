# Set the proxy server information
$proxyServer = "proxy.example.com:8080"

# Set the web sites to add to Trusted sites
$trustedSites = @("https://example.com", "https://www.example.com")

# Set the registry key paths for Internet Explorer settings
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

# Test connection to the proxy server
$testConnection = Test-NetConnection -ComputerName $proxyServer -Port 8080
if ($testConnection.TcpTestSucceeded -eq $false) {
    Write-Host "Unable to connect to the proxy server on port 8080. Proxy will not be enabled." -ForegroundColor Red
} else {
    # Enable the proxy server
    Set-ItemProperty -Path $registryPath -Name ProxyEnable -Value 1
    Set-ItemProperty -Path $registryPath -Name ProxyServer -Value $proxyServer

    # Add the web sites to Trusted sites
    $trustedSitesValue = $trustedSites -join "`n"
    Set-ItemProperty -Path $registryPath -Name TrustedSites -Value $trustedSitesValue
    Set-ItemProperty -Path $registryPath -Name "ZoneMapKey" -Value 2 -Type DWORD

    Write-Host "Proxy server enabled and web sites added to Trusted sites." -ForegroundColor Green
}
