function Get-ServerStatus 
{

Param
    (
        # Computer name
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $computer
    )

if ((Test-Connection -ComputerName $computer -Count 2 -Quiet) -eq $True)
        {
            Write-Host "Server is up"
            
        } 
   else 
        {
            Write-Host "Server is down"
            $service = Get-Service -ComputerName localhost -Name Schedule
                if ($service.Status -ne 'Running')
                    {Set-Service -Name Schedule -StartupType Automatic | Start-Service -Name Schedule }
                else 
                    {Write-Host "There is a problem"}
        }
}