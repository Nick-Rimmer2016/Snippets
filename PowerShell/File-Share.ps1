Configuration FileServer
{
	Import-DscResource -Module xSmbShare,cNtfsAccessControl
	
	Node 'VM1'
	{
		# Setup folder structure
		File 'MainDirectory'
		{
			Ensure = 'Present'
			Type = 'Directory'
			DestinationPath = 'C:\MainData'
		}
		
		File 'SecondaryDirectory'
		{
			Ensure = 'Present'
			Type = 'Directory'
			DestinationPath = 'C:\SecondaryData'
		}
		# Setup Shares
		xSmbShare 'datashare0'
		{
			Ensure = 'Present'
			Name   = 'datashare0'
			Path = 'C:\MainData'
			FullAccess = 'Everyone'
			DependsOn = '[File]MainDirectory'
		}
		
		xSmbShare 'datashare1'
		{
			Ensure = 'Present'
			Name   = 'datashare1'
			Path = 'C:\SecondaryData'
			FullAccess = 'Everyone'
			DependsOn = '[File]SecondaryDirectory'
		}
		# Setup Permissions
		cNtfsPermissionEntry 'datashare0' {
			Ensure = 'Present'
			DependsOn = "[File]MainDirectory"
			Principal = 'Authenticated Users'
			Path = 'C:\MainData'
			AccessControlInformation = @(
				cNtfsAccessControlInformation
				{
					AccessControlType = 'Allow'
					FileSystemRights = 'Read'
					Inheritance = 'ThisFolderSubfoldersAndFiles'
					NoPropagateInherit = $false
				}
			)
		}
		
		cNtfsPermissionEntry 'datashare1' {
			Ensure = 'Present'
			DependsOn = "[File]SecondaryDirectory"
			Principal = 'Authenticated Users'
			Path = 'C:\SecondaryData'
			AccessControlInformation = @(
				cNtfsAccessControlInformation
				{
					AccessControlType = 'Allow'
					FileSystemRights = 'Read'
					Inheritance = 'ThisFolderSubfoldersAndFiles'
					NoPropagateInherit = $false
				}
			)
		}
		
	}
}

FileServer -OutputPath C:\scripts
Start-DscConfiguration -Force -Wait -path c:\scripts -ComputerName VM1 -Verbose

$results = Test-DscConfiguration -Detailed -Verbose
	if ($results.InDesiredState -eq $false)
			{Write-EventLog -LogName Automation -Source AutoMessage -EventId 9000 -EntryType Error -Message "Out of desired state"}
		else {Write-EventLog -LogName Automation -Source AutoMessage -EventId 9001 -EntryType Information -Message "In desired state"}
		

New-EventLog -LogName Automation -source AutoMessage 
Get-EventLog -LogName Automation