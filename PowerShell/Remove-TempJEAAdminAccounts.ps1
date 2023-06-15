<#
.Synopsis
   Remove JEA Temporary Admin Accounts
.DESCRIPTION
   This is a bug that exists in Windows Server 2012 R2, where after a JEA session with the virtual account setting 
   switch on, the session does not exit cleanly and leave the virtual account in logon as a service.
   https://github.com/PowerShell/PowerShell/issues/5296 (This has been fixed in 2016 & 2019)
   https://gallery.technet.microsoft.com/scriptcenter/Grant-Revoke-Query-user-26e259b0
.EXAMPLE
   Remove-TempJEAAdminAccounts -backup c:\backups  (Only specify drive and folder here), the file will be assigned the name 
   SeServiceLogonRight-backup.txt

#>
function Remove-TempJEAAdminAccounts
{
[CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Backup Param description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$backup = "c:"
    )
    if (Get-Module -ListAvailable -Name UserRights) {Write-Verbose "Module exists"} 
                else {Write-Verbose "Module does not exist"; exit 0}
             
    Write-Verbose "Gather Account List"
    $names = (Get-AccountsWithUserRight -Right SeServiceLogonRight).Account
    Write-Verbose "Output Accounts to a text file for backup $backup\SeServiceLogonRight-backup.txt"
    $names | Out-file $backup\SeServiceLogonRight-backup.txt

    $names | foreach {

           if ($_ -Match 'WinRM Virtual Users*')
            {
                Write-Verbose "Deleting $_"
                Revoke-UserRight -Right SeServiceLogonRight -Account $_
            }
           else {Write-Verbose "Keeping Account $_"}
        }
}
