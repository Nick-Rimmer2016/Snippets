# Import the ImportExcel module
Import-Module ImportExcel

function Generate-IndexFilenames {
    param (
        [int]$StartYear,
        [int]$EndYear
    )

    # Initialize an empty array to hold the filenames
    $indexFiles = @()

    # Loop through each year and each two-week period of each year
    for ($year = $StartYear; $year -le $EndYear; $year++) {
        $currentDate = Get-Date -Year $year -Month 1 -Day 1
        $endOfYear = Get-Date -Year $year -Month 12 -Day 31
        
        while ($currentDate -le $endOfYear) {
            # Calculate end date
            $endDate = $currentDate.AddDays(13)
            
            # Generate filename
            $filename = "index_$($currentDate.ToString('dd_MM_yyyy'))-$($endDate.ToString('dd_MM_yyyy')).txt"

            
            # Add filename to array
            # Add filename to array
            $archiveName = ($filename -replace 'Index', 'Archive' -replace '.txt', '.gz').ToLower()
            $indexFiles += [PSCustomObject]@{
                'Year'        = $year
                'Filename'    = $filename
                'StartDate'   = $currentDate.ToString('dd_MM_yyyy')
                'EndDate'     = $endDate.ToString('dd_MM_yyyy')
                'ArchiveName' = $archiveName
                'Date Sent'   = $datesent
            }


            
            # Update current date for next iteration
            $currentDate = $endDate.AddDays(1)
        }
    }

    # Output generated filenames to Excel
    $excelPath = "Index_Filenames_${StartYear}_to_${EndYear}.xlsx"
    $excelPackage = $indexFiles | Export-Excel -Path $excelPath -WorksheetName "IndexFiles" -AutoSize -BoldTopRow -PassThru

    # Remove gridlines
    $ws = $excelPackage.Workbook.Worksheets["IndexFiles"]
    $ws.View.ShowGridLines = $false

    # Align "Year" column to the left
    $yearColumn = $ws.Column(1)
    $yearColumn.Style.HorizontalAlignment = [OfficeOpenXml.Style.ExcelHorizontalAlignment]::Left

    # Set the top row's background color to orange
    $ws.Row(1).Style.Fill.PatternType = [OfficeOpenXml.Style.ExcelFillStyle]::Solid
    $ws.Row(1).Style.Fill.BackgroundColor.SetColor([System.Drawing.Color]::Orange)

    # Save and dispose of the Excel package
    $excelPackage.Save()
    $excelPackage.Dispose()

    Write-Host "Generated index filenames for the years $StartYear to $EndYear have been saved to $excelPath"



}