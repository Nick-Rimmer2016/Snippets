# Ensure Pester module is available
Import-Module Pester -Version 3.4.0

# Define the paths to the folders, the text file, and the scheduled task name
$folderPath1 = "C:\Path\To\First\Folder"
$folderPath2 = "C:\Path\To\Second\Folder"
$textFilePath = "C:\Path\To\File.txt"
$scheduledTaskName = "MyScheduledTask"

# Define the Pester tests
Describe 'Folder, File, and Scheduled Task Tests' {

    Context 'Folder Existence Tests' {

        It 'First folder should exist' {
            Test-Path $folderPath1 | Should Be $true
        }

        It 'Second folder should exist' {
            Test-Path $folderPath2 | Should Be $true
        }
    }

    Context 'Text File Content Test' {

        It 'Text file should contain text that begins with "dt0"' {
            $content = Get-Content $textFilePath -Raw
            $content | Should Match '^dt0'
        }
    }

    Context 'Scheduled Task Test' {

        It 'Scheduled task should exist' {
            $task = Get-ScheduledTask | Where-Object { $_.TaskName -eq $scheduledTaskName }
            $task | Should Not Be $null
        }
    }
}

# Invoke the Pester tests
Invoke-Pester
