function Generate-Filenames {
    param (
        [int]$year,
        [string]$label
    )
    
    $output = @()

    for ($quarter = 1; $quarter -le 4; $quarter++) {
        $startDate = Get-Date -Year $year -Month (3 * ($quarter - 1) + 1) -Day 1
        $endDate = $startDate.AddMonths(3).AddDays(-1)
        
        $filename = "Q${quarter}_${year}_${label}_${quarter}"
        
        $output += [PSCustomObject]@{
            Year = $year
            Quarter = $quarter
            StartDate = $startDate
            EndDate = $endDate
            Label = $label
            Filename = $filename
        }
    }

    return $output
}

$year = 2023
$label = "TEMP"

$filenames = Generate-Filenames -year $year -label $label
$filenames | Format-Table -AutoSize
