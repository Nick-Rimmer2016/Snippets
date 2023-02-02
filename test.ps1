$outputFile = "output.txt"
$records = @(
)

$data = @()
foreach ($record in $records) {
    $lines = $record -split "`n"
    $docType = ($lines | Where-Object { $_ -like ">>DocType:*" }).Split(":")[1].Trim()
    $docDate = ($lines | Where-Object { $_ -like ">>DocDate:*" }).Split(":")[1].Trim()
    $CI = ($lines | Where-Object { $_ -like "CI:*" }).Split(":")[1].Trim()
    $ORG = ($lines | Where-Object { $_ -like "ORG:*" }).Split(":")[1].Trim()
    $diskgroupNums = ($lines | Where-Object { $_ -like ">>DiskgroupNum:*" }).Split(":")[1].Trim()
    $disks = ($lines | Where-Object { $_ -like ">>Disk:*" }).Split(":")[1].Trim()
    $fileNames = ($lines | Where-Object { $_ -like ">>FileName:*" }).Split(":")[1].Trim()
    for ($i = 0; $i -lt $diskgroupNums.Count; $i++) {
        $data += "$docType|$docDate|$CI|$ORG|$diskgroupNums[$i]|$disks[$i]|$fileNames[$i]"
    }
}

$data | Set-Content -Path $outputFile
