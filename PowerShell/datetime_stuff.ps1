$string = 'srv1 02-Dec-19'
$server,$strdate = $string.split(' ')
[datetime]$date = [datetime]::parseexact($strdate, 'dd-MMM-yy', $null).ToString('dd-MM-yyyy')