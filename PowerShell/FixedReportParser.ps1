# Read the file contents
$contents = Get-Content -Path "C:\path\to\your\file.txt"

# Initialize variables to store the extracted values
$reportIds = @()
$versionIds = @()
$exportPaths = @()
$sectionIds = @()

# Process the file contents in chunks of four lines
for ($i = 0; $i -lt $contents.Count; $i += 4) {
    # Extract the report ID using regular expression matching
    $reportId = [regex]::Match($contents[$i], "REP\s+'([^']+)'").Groups[1].Value
    $reportIds += $reportId

    # Extract the version ID using regular expression matching
    $versionId = [regex]::Match($contents[$i], "VER\s+'([^']+)'").Groups[1].Value
    $versionIds += $versionId

    # Extract the export ASCII file path using regular expression matching
    $exportPath = [regex]::Match($contents[$i + 2], "EXPORT\s+'([^']+)'").Groups[1].Value
    $exportPaths += $exportPath

    # Extract the section ID using regular expression matching
    $sectionId = [regex]::Match($contents[$i], "SEC\s+'([^']+)'").Groups[1].Value
    $sectionIds += $sectionId
}

# Combine the extracted values into a single array of objects
$data = for ($i = 0; $i -lt $reportIds.Count; $i++) {
    [PSCustomObject]@{
        ReportId = $reportIds[$i]
        VersionId = $versionIds[$i]
        ExportPath = $exportPaths[$i]
        SectionId = $sectionIds[$i]
    }
}

# Export the data to a CSV file
$data | Export-Csv -Path "C:\path\to\output.csv" -NoTypeInformation
