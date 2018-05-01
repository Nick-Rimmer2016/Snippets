# Pre-Req's for Building VM

# Set IE Enh to off
function Disable-ieESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
Disable-ieESC

# Disable Server Manager on logon
function DisableSrvManager {
    New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "0x1" –Force}
DisableSrvManager

# Resize OS partition, Create New partition for applications
# Check if it's been partitioned
function ctxResize {
$part = Get-Partition | where {$_.DriveLetter -eq 'C'}
Resize-Partition -DiskNumber $part.DiskNumber -PartitionNumber $part.PartitionNumber -Size (80gb)
New-Partition -DiskNumber $part.DiskNumber -UseMaximumSize -DriveLetter E
$currentconfirm = $confirmpreference
$confirmpreference = 'none'
Format-Volume -Driveletter E -NewFileSystemLabel 'Data'
    $confirmpreference = $currentconfirm }


# Configure LCM
[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node localhost
    {
    Settings

        {
            RefreshMode        = 'Push'
            RebootNodeIfNeeded = $True
        }
    }
}
LCMConfig
Set-DscLocalConfigurationManager -Path C:\Files\LCMConfig -Force


#Citrix Install
$arg0 = " /quiet /masterimage /disableexperiencemetrics /components VDA"
$arg0 += " /masterimage /virtualmachine /optimize"
#$arg0 += " /noreboot"
Start-Process -FilePath C:\files\VDAServerSetup_7.17.exe `
-ArgumentList $arg0


function Write-Log {
     [CmdletBinding()]
     param(
         [Parameter()]
         [ValidateNotNullOrEmpty()]
         [string]$Message,
 
         [Parameter()]
         [ValidateNotNullOrEmpty()]
         [ValidateSet('Information','Warning','Error')]
         [string]$Severity = 'Information'
     )
 
     [pscustomobject]@{
         Time = (Get-Date -f g)
         Message = $Message
         Severity = $Severity } | Export-Csv -Path "c:\files\LogFile.csv" -Append -NoTypeInformation
 }