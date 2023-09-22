# Prompt user for the year
$year = Read-Host "Enter the year for which you want to generate index filenames"

# Initialize an empty array to hold the filenames
$indexFiles = @()

# Loop through each two-week period of the year
for ($month = 1; $month -le 12; $month++) {
    # Get the number of days in the current month
    $daysInMonth = [DateTime]::DaysInMonth($year, $month)
    
    # Initialize start day
    $startDay = 1
    
    while ($startDay -le $daysInMonth) {
        # Calculate end day
        $endDay = $startDay + 13
        if ($endDay -gt $daysInMonth) {
            $endDay = $daysInMonth
        }
        
        # Generate filename
        $startDate = Get-Date -Year $year -Month $month -Day $startDay -Hour 0 -Minute 0 -Second 0
        $endDate = Get-Date -Year $year -Month $month -Day $endDay -Hour 0 -Minute 0 -Second 0
        $filename = "Index_$($startDate.ToString('dd_MM_yyyy'))-$($endDate.ToString('dd_MM_yyyy')).txt"
        
        # Add filename to array
        $indexFiles += $filename
        
        # Update start day for next iteration
        $startDay = $endDay + 1
    }
}

# Output generated filenames
Write-Host "Generated index filenames for the year $year :"
$indexFiles | ForEach-Object { Write-Host $_ }
