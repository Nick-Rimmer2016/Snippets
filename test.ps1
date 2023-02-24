# Set the proxy server information
$proxyServer = "proxy.example.com:8080"

# Set the web sites to add to Trusted sites
$trustedSites = @("http://example.com", "http://www.example.com")

# Set the registry key paths for Internet Explorer settings
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

# Enable the proxy server
Set-ItemProperty -Path $registryPath -Name ProxyEnable -Value 1
Set-ItemProperty -Path $registryPath -Name ProxyServer -Value $proxyServer

# Add the web sites to Trusted sites
$trustedSitesValue = $trustedSites -join "`n"
Set-ItemProperty -Path $registryPath -Name TrustedSites -Value $trustedSitesValue
Set-ItemProperty -Path $registryPath -Name "ZoneMapKey" -Value 2 -Type DWORD
