# Read the individual snippets
$systemInfoHTML = Get-Content -Path "SystemInfo.html" -Raw
$diskUsageHTML = Get-Content -Path "DiskUsage.html" -Raw
$networkStatusHTML = Get-Content -Path "NetworkStatus.html" -Raw

# Combine snippets into a single report
$reportHTML = @"
<!DOCTYPE html>
<html>
<head>
    <title>Environment Report</title>
    <style>
        body { font-family: Arial, sans-serif; }
        h2 { color: #2e6c80; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 8px; text-align: left; border: 1px solid #dddddd; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Environment Report</h1>
    $systemInfoHTML
    $diskUsageHTML
    $networkStatusHTML
</body>
</html>
"@

# Save the final report
$reportHTML | Out-File -FilePath "EnvironmentReport.html"
