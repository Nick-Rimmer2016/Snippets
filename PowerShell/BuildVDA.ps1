pushd c:\files
configuration BuildVDA
{

param (
        [string[]]$Computername
      )
        
Import-DscResource –ModuleName PSDesiredStateConfiguration
Import-DscResource -ModuleName xPSDesiredStateConfiguration
Import-DscResource -ModuleName xWindowsupdate


     node $Computername
    {
        
        Package Silverlight
        {
           Ensure = "Present"
           Name = "Microsoft Silverlight"
           Path = "C:\Files\Silverlight_x64.exe"
           ProductID = "89F4137D-6C26-4A84-BDB8-2E5A4BB71E00"
           Arguments = "/q /noupdate /noreboot"
        }
        Package AcrobatDC
        {
           Ensure = "Present"
           Name = "Adobe Acrobat Reader DC"
           Path = "C:\Files\AcroRdrDC1801120035_en_US.exe"
           ProductID = "AC76BA86-7AD7-1033-7B44-AC0F074E4100"
           Arguments = "/sPB /rs /msi"
        }
        xHotFix Powershell
        {
            Path="c:\files\Win8.1AndW2K12R2-KB3191564-x64.msu"
            Id="KB3191564"
            Ensure="Present"
        }
        WindowsFeature RDS
        {
            Ensure = "Present"
            Name = "RDS-RD-Server"
        }

        WindowsFeature ASPDotNet
        {
            Ensure = "Present"
            Name = "NET-Framework-45-ASPNET"
        }

        File Scripts
        {
            Ensure = "Present"
            Type = "Directory"
            SourcePath = "c:\files\scripts"
            DestinationPath = "e:\scripts"
            Recurse = $true
        }

        File Logs
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "e:\log"
        }
    
    }
}

BuildVDA -Computername PSDEVOPS-APP4 
Start-DscConfiguration -Wait -Path C:\files\BuildVDA  -Verbose -Force