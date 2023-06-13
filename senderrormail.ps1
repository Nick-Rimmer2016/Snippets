function Send-ErrorEmail {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord,

        [Parameter(Mandatory = $true)]
        [string]
        $Recipient,

        [Parameter(Mandatory = $true)]
        [string]
        $Sender,

        [Parameter(Mandatory = $true)]
        [string]
        $SmtpServer,

        [Parameter(Mandatory = $true)]
        [string]
        $Subject
    )

    $errorDetails = @{
        'DateTime'   = (Get-Date).ToString()
        'Message'    = $ErrorRecord.Exception.Message
        'StackTrace' = $ErrorRecord.Exception.StackTrace
    }

    $errorBody = @"
ERROR DETAILS:

DateTime   : $($errorDetails['DateTime'])
Message    : $($errorDetails['Message'])
StackTrace : $($errorDetails['StackTrace'])
"@

    Send-MailMessage -To $Recipient -From $Sender -SmtpServer $SmtpServer -Subject $Subject -Body $errorBody
}
