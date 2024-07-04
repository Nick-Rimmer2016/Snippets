configuration SetupIIS
{
    param (
        [string]$NodeName = 'localhost',
        [string]$WebsiteName = 'testsite',
        [string]$WebsitePath = "C:\inetpub\wwwroot\$WebsiteName",
        [string]$HtmlFileName = 'index.html',
        [string]$HtmlContent = '<html><body><h1>Welcome to Test Site!</h1></body></html>'
    )

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node $NodeName
    {
        # Install IIS
        WindowsFeature IIS
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        # Ensure the website directory exists
        File WebsiteDirectory
        {
            Ensure          = 'Present'
            Type            = 'Directory'
            DestinationPath = $WebsitePath
            DependsOn       = '[WindowsFeature]IIS'
        }

        # Create the HTML file with specified content
        File HtmlFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$WebsitePath\$HtmlFileName"
            Contents        = $HtmlContent
            DependsOn       = '[File]WebsiteDirectory'
        }

        # Set up the website
        xWebsite TestSite
        {
            Ensure          = 'Present'
            Name            = $WebsiteName
            PhysicalPath    = $WebsitePath
            BindingInfo     = @(
                MSFT_xWebBindingInformation {
                    Protocol              = 'HTTP'
                    Port                  = 80
                    IpAddress             = '*'
                }
            )
            DependsOn       = '[WindowsFeature]IIS'
        }
    }
}

# Apply the configuration
SetupIIS -OutputPath 'C:\DSC\SetupIIS'
Start-DscConfiguration -Path 'C:\DSC\SetupIIS' -Wait -Verbose -Force
