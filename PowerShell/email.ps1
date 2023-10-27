# Define SMTP server and email details
$smtpServer = "[SMTP Server Address]"
$smtpPort = 587 # Use your SMTP port number
$smtpUser = "[SMTP User]"
$smtpPassword = "[SMTP Password]"

$fromEmail = "[Sender's Email]"
$toEmail = "[Recipient's Email]"
$subject = "Log File Contents"

# Path to the log file
$logFilePath = "C:\path\to\your\log.txt"

# Read log file
if (Test-Path -Path $logFilePath) {
    $logContent = Get-Content -Path $logFilePath | Out-String

    # Prepare email body
    $body = "Please find the log file contents below:`n`n$logContent"

    # Send email
    Send-MailMessage -From $fromEmail -To $toEmail -Subject $subject -Body $body -SmtpServer $smtpServer -Port $smtpPort -Credential (New-Object System.Management.Automation.PSCredential ($smtpUser, (ConvertTo-SecureString $smtpPassword -AsPlainText -Force))) -UseSsl
    Write-Host "Email sent successfully."
} else {
    Write-Host "Log file not found."
}
