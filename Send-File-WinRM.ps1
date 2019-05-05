function Send-File-WinRM {
    [CmdletBinding()]
    param (
            # Parameter help description
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,Position=0)]
            [string]$ComputerName,
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,Position=1)]
            [string]$Source,
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,Position=2)]
            [string]$Destination,
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,Position=3)]
            [string]$Extension
      
    )
    
    begin {
            Write-Verbose "Collect File List"
           
          }
    
    process {
        try {
                $files = Get-ChildItem $source -Filter *.$extension
                        if (!$files) {Write-EventLog -LogName CopyFile -Source SF -EventId 9005 -EntryType Warning -Message "No Files To Copy"; exit 0}
                $session = New-PSSession -ComputerName $ComputerName -Credential $creds -UseSSL 
                Copy-Item -Path $files.FullName -Destination $destination -ToSession $session -Verbose -ErrorAction Stop
                Remove-Item -Path $files.FullName -Confirm:$false -Force -Verbose
                Remove-PSSession $session
            }
        catch 
           {
                Write-Verbose "The following error has occurred: $_"
                Write-EventLog -LogName CopyFile -Source SF -EventId 9005 -EntryType Error -Message "Remoting or Copy Issue"
           }
            
            }
    
    end {
            Write-Verbose "File Copy Completed"
    }
}
