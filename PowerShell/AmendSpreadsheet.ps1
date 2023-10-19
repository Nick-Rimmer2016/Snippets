# Import the Excel module
Import-Module ImportExcel

# Define the paths for the source CSV and the target Excel file
$csvPath = "C:\path\to\your\input.csv"
$xlsxPath = "C:\path\to\your\output.xlsx"

# Convert the CSV to Excel
$excel = Import-Csv $csvPath | Export-Excel $xlsxPath -PassThru

# Get the worksheet object
$worksheet = $excel.Workbook.Worksheets[1]

# Auto-space all columns
for ($i = 1; $i -le $worksheet.Dimension.Columns; $i++) {
    $worksheet.Column($i).AutoFit()
}

# Add filter to the top line
$worksheet.Cells["1:1"].AutoFilter = $true

# Find and remove the column named 'ID'
$IDColumnName = $null
$colCount = $worksheet.Dimension.Columns
for ($i = 1; $i -le $colCount; $i++) {
    $cellValue = $worksheet.Cells[1, $i].Text
    if ($cellValue -eq "ID") {
        $IDColumnName = $i
        break
    }
}

if ($IDColumnName -ne $null) {
    $worksheet.Column($IDColumnName).Delete()
}

# Save the changes and dispose of the Excel package
$excel.Save()
$excel.Dispose()
