It "Should have a disk size of 100GB" {
        # Get the disk size of the C: drive (change as necessary)
        $disk = Get-PSDrive -Name C
        
        # Convert the disk size from bytes to GB
        $diskSizeGB = [math]::Round($disk.Used / 1GB, 2)
        
        # Check if the disk size is 100GB
        $diskSizeGB | Should -Be 100
    }
