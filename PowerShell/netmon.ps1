$processName = "YourProcessName" # Replace with the name of your process
$interval = 1 # Interval in seconds

while ($true) {
    # Get the process ID for the specified process name
    $pid = Get-Process -Name $processName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id

    if ($pid) {
        # Run netstat and filter results for the specified PID
        netstat -ano | Where-Object { $_ -match "\s$pid\s" } | ForEach-Object { $_ }

        # Output a separator for clarity
        Write-Output "---- $(Get-Date) ----"
    } else {
        Write-Output "Process $processName not found."
    }

    # Wait for the specified interval
    Start-Sleep -Seconds $interval
}
