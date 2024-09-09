# Read the servers from the text file
$servers = Get-Content "C:\servers.txt"

# Create an array of custom objects with 'Server Name' as a property
$serverObjects = $servers | ForEach-Object { [pscustomobject]@{ 'ServerName' = $_ } }

# Define the CSS for the table
$css = @"
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        margin: 0;
        padding: 20px;
    }
    h1 {
        text-align: center;
        color: #333;
    }
    table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        background-color: #fff;
    }
    th, td {
        padding: 12px 15px;
        border: 1px solid #ddd;
        text-align: left;
    }
    th {
        background-color: #4CAF50;
        color: white;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    tr:hover {
        background-color: #f1f1f1;
    }
</style>
"@

# Convert the list of server objects to HTML with the inline CSS
$htmlContent = $serverObjects | ConvertTo-Html -Property ServerName -PreContent "<h1>Server List</h1>" -Head $css

# Save the HTML content to a file
$htmlContent | Out-File "C:\server_list.html"
