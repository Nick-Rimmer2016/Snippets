# Define the path to the HTML file
$htmlFilePath = "C:\Path\To\YourFile.html"

# Read the HTML content from the file
$htmlContent = Get-Content -Path $htmlFilePath -Raw

# Load the HTML content into an XML object for parsing
[xml]$html = $htmlContent

# Iterate over each row in the table
foreach ($row in $html.getElementsByTagName("tr")) {
    foreach ($cell in $row.getElementsByTagName("td")) {
        if ($cell.InnerText -match "TEST") {
            # Add inline CSS to highlight the row in red
            $row.setAttribute("style", "background-color:red;")
            break
        }
    }
}

# Convert the modified XML object back to HTML
$htmlContentModified = $html.OuterXml

# Save the modified HTML content back to the file
Set-Content -Path $htmlFilePath -Value $htmlContentModified

Write-Output "The HTML file has been updated."
