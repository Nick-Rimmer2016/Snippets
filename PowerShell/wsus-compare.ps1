# Define WSUS and AD servers
$WsusServers = Get-WsusComputer | Select-Object -ExpandProperty FullDomainName
$AdServers = Get-ADComputer -Filter * | Select-Object -ExpandProperty DNSHostName

# Compare the two lists
$MissingFromWsus = $AdServers | Where-Object { $_ -notin $WsusServers }

# Output results
if ($MissingFromWsus.Count -gt 0) {
    Write-Host "The following servers are missing from WSUS:" -ForegroundColor Red
    $MissingFromWsus | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
} else {
    Write-Host "All AD servers are accounted for in WSUS." -ForegroundColor Green
}

# Optional: Export the missing servers to a file
$MissingFromWsus | Out-File -FilePath "MissingFromWSUS.txt"
