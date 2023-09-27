# Import the ImportExcel module
Import-Module ImportExcel

# Prompt user for the start and end years
$startYear = Read-Host "Enter the start year for which you want to generate index filenames"
$endYear = Read-Host "Enter the end year for which you want to generate index filenames"

# Initialize an empty array to hold the filenames
$indexFiles = @()

# Loop through each year and each two-week period of each year
for ($year = $startYear; $year -le $endYear; $year++) {
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
            $indexFiles += [PSCustomObject]@{
                'Year' = $year
                'Filename' = $filename
                'StartDate' = $startDate.ToString('dd_MM_yyyy')
                'EndDate' = $endDate.ToString('dd_MM_yyyy')
            }
            
            # Update start day for next iteration
            $startDay = $endDay + 1
        }
    }
}

# Output generated filenames to Excel
$excelPath = "Index_Filenames_${startYear}_to_${endYear}.xlsx"
$indexFiles | Export-Excel -Path $excelPath -WorksheetName "IndexFiles"

Write-Host "Generated index filenames for the years $startYear to $endYear have been saved to $excelPath"
