function Compress-Data 
{
    <#
    .Synopsis
        Compresses data
    .Description
        Compresses data into a GZipStream
    .Link
        Expand-Data
    .Link
        http://msdn.microsoft.com/en-us/library/system.io.compression.gzipstream.aspx
    .Example
        $rawData = (Get-Command | Select-Object -ExpandProperty Name | Out-String)
        $originalSize = $rawData.Length
        $compressed = Compress-Data $rawData -As Byte
        "$($compressed.Length / $originalSize)% Smaller [ Compressed size $($compressed.Length / 1kb)kb : Original Size $($originalSize /1kb)kb] "
        Expand-Data -BinaryData $compressed
    .Usage 
        .\compress_gzip.ps1
        $content = [IO.File]::ReadAllText("path to file")
        Compress-Data $content -As String > gzip_compressed_payload
    #>
    [OutputType([String],[byte])]
    [CmdletBinding(DefaultParameterSetName='String')]
    param(
    # A string to compress
    [Parameter(ParameterSetName='String',
        Position=0,
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    [string]$String,
    
    # A byte array to compress.
    [Parameter(ParameterSetName='Data',
        Position=0,
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    [Byte[]]$Data,
    
    # Determine how the data is returned.
    # If set to byte, the data will be returned as a byte array. If set to string, it will be returned as a string.
    [ValidateSet('String','Byte')]
    [String]$As = 'string'   
    )
    
    process {
           
        if ($psCmdlet.ParameterSetName -eq 'String') {
            $Data= foreach ($c in $string.ToCharArray()) {
                $c -as [Byte]
            }            
        }
        
        #region Compress Data
        $ms = New-Object IO.MemoryStream                
        $cs = New-Object System.IO.Compression.GZipStream ($ms, [Io.Compression.CompressionMode]"Compress")
        $cs.Write($Data, 0, $Data.Length)
        $cs.Close()
        #endregion Compress Data
        
        #region Output CompressedData
        if ($as -eq 'Byte') {
            $ms.ToArray()
            
        } elseif ($as -eq 'string') {
            [Convert]::ToBase64String($ms.ToArray())
        }
        $ms.Close()
        #endregion Output CompressedData
    }
}
