function Get-Web {
    [cmdletbinding()]
    
    param (
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [System.Uri]$url,
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [String]$filename,
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [String]$org
          )

    Begin {Write-Verbose "Checking WebSites  ..."}

    Process {
        try {
            Write-Verbose "Check $org"
            $sitealive = Invoke-WebRequest -Uri $url -DisableKeepAlive -UseBasicParsing -Method HEAD
                if ((Test-Path -path E:\Scripts\$filename) -eq $false)
                    {
                    Write-Verbose "No older files present, downloading now"
                    Invoke-WebRequest -Uri $url -DisableKeepAlive -UseBasicParsing -OutFile $filename             
                    }
            
                Else {  
                    $last = (gci $filename).LastWriteTime
                    if ($sitealive.BaseResponse.LastModified -gt $last ) {
                        Write-Verbose "The latest file needs to be downloaded"
                        Invoke-WebRequest -Uri $url -DisableKeepAlive -UseBasicParsing -OutFile $filename
                    }
                    else {Write-Verbose "We have the latest file"}
                 }
            
                 }
        catch {
            
                Write-Verbose -message $_.exception
                Write-EventLog -LogName TEST -Source Web -EntryType Error -EventId 10000 -Message $_.exception
              }
       
        }
        
     End {
                Write-Verbose "Finished Processing"
         }
    }
