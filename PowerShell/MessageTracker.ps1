param (
    [string]$MessageId,
    [string]$Sender,
    [DateTime]$Start = (Get-Date).AddDays(-1),
    [DateTime]$End = (Get-Date)
)

if (-not $MessageId -and -not $Sender) {
    Write-Host "Please provide either -MessageId or -Sender." -ForegroundColor Yellow
    return
}

$filterParams = @{
    Start = $Start
    End = $End
}

if ($MessageId) {
    $filterParams.MessageId = $MessageId
} elseif ($Sender) {
    $filterParams.Sender = $Sender
}

$logs = Get-MessageTrackingLog @filterParams |
    Sort-Object Timestamp |
    Select Timestamp, EventId, Source, SourceContext, ServerHostname, ConnectorId, Recipients, RecipientStatus, MessageSubject

$logs | Format-Table -AutoSize
