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

# File info
$logFile = "$PSScriptRoot\mylog.txt"
 
$exists = Test-Path -Path $logFile
if ($exists)
{
  $data = Get-Item -Path $logFile
  if ($data.Length -gt 100KB)
  {
    Remove-Item -Path $logFile
  }
 
} 

#Passwords
$Path = "$home\Desktop\multipass.xml"
 
[PSCustomObject]@{
    User1 = Get-Credential -Message User1
    User2 = Get-Credential -Message User2
    User3 = Get-Credential -Message User3
} | Export-Clixml -Path $Path  

$multipass = Import-Clixml -Path $Path 
