$invoice='01-Jul-19'
[datetime]::parseexact($invoice, 'dd-MMM-yy', $null).ToString('dd-MM-yyyy')