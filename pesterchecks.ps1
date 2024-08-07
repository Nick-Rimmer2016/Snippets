It 'RDP should be enabled' {
        # Path to the RDP registry key
        $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server'
        $valueName = 'fDenyTSConnections'
        
        # Get the value of the RDP setting
        $rdpSetting = Get-ItemProperty -Path $regPath -Name $valueName
        
        # Check if the setting exists and is set to 0 (0 means RDP is enabled)
        $rdpSetting.$valueName | Should Be 0
    }
