# Create a new folder called "test"
New-Item -ItemType Directory -Path C:\ -Name test

# Remove inherited permissions
$Acl = Get-Acl "C:\test"
$Acl.SetAccessRuleProtection($true, $false)
Set-Acl "C:\test" $Acl

# Add permissions for specific users and local administrators group
$User = New-Object System.Security.Principal.NTAccount("DOMAIN\username")
$Rights = [System.Security.AccessControl.FileSystemRights]::FullControl
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::None
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($User, $Rights, $InheritanceFlag, $PropagationFlag, "Allow")
$Acl = Get-Acl "C:\test"
$Acl.SetAccessRule($AccessRule)
$Admins = New-Object System.Security.Principal.NTAccount("BUILTIN\Administrators")
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($Admins, "FullControl", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "C:\test" $Acl

# Share the folder with the name "test"
New-SmbShare -Name test -Path C:\test -FullAccess "DOMAIN\username","BUILTIN\Administrators"
