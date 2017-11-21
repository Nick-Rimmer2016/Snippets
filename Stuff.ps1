# Transcript Logging
#
$logFile = "e:\test\mylog.txt"
Start-Transcript -Path $logFile -Append -
######################################### 
 
"Hello" 
 ($a = Get-Service)
 dir
 
"I received $($a.Count) services."
Write-Host "Watch out: direct output will not be logged!"

