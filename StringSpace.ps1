$string = "   This is a  string  with  extra  spaces  and  line  breaks.  `n  `n  `r  "
$newString = $string -replace "\s+", " " -replace "(?<!`n|`r)\s+(?!`n|`r)", ""