$rdpTcpSettings = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
$thumbprint = $rdpTcpSettings.SSLCertificateSHA1Hash

# Check the certificate store for the matching certificate
Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Thumbprint -eq $thumbprint } | Select-Object Subject, Issuer, Thumbprint
