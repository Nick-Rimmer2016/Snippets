# Ensure Pester module is available
Import-Module Pester -Version 3.4.0

# Define the path to the tab-delimited text file
$serversFilePath = "C:\Path\To\servers.txt"

# Read the servers information from the text file
$serversInfo = Import-Csv -Path $serversFilePath -Delimiter "`t"

# Function to test remote server
function Test-RemoteServer {
    param (
        [string]$server,
        [string]$scriptPath,
        [string]$scheduledTaskName
    )

    $results = @{}

    try {
        # Check if the script exists
        $scriptExists = Invoke-Command -ComputerName $server -ScriptBlock { param($path) Test-Path $path } -ArgumentList $scriptPath
        $results.ScriptExists = $scriptExists

        # Check if the scheduled task exists and get its details
        $taskDetails = Invoke-Command -ComputerName $server -ScriptBlock {
            param($taskName)
            $task = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName }
            if ($task) {
                return @{
                    TaskExists = $true
                    Enabled = $task.Enabled
                    LastRunTime = $task.LastRunTime
                    LastTaskResult = $task.LastTaskResult
                }
            } else {
                return @{
                    TaskExists = $false
                }
            }
        } -ArgumentList $scheduledTaskName
        $results += $taskDetails
    } catch {
        $results.Error = $_.Exception.Message
    }

    return $results
}

# Define the Pester tests
Describe 'Remote Server Checks' {

    foreach ($serverInfo in $serversInfo) {
        $server = $serverInfo.ServerName
        $environment = $serverInfo.Environment
        $scheduledTaskName = $serverInfo.Scheduled_task
        $scriptPath = $serverInfo.Scriptname

        Context "Checking server: $server ($environment)" {

            $results = Test-RemoteServer -server $server -scriptPath $scriptPath -scheduledTaskName $scheduledTaskName

            It "Script '$scriptPath' should exist on $server ($environment)" {
                $results.ScriptExists | Should Be $true
            }

            It "Scheduled task '$scheduledTaskName' should exist on $server ($environment)" {
                $results.TaskExists | Should Be $true
            }

            if ($results.TaskExists) {
                It "Scheduled task '$scheduledTaskName' should be enabled on $server ($environment)" {
                    $results.Enabled | Should Be $true
                }

                It "Scheduled task '$scheduledTaskName' should have run successfully on $server ($environment)" {
                    $results.LastTaskResult | Should Be 0
                }

                It "Scheduled task '$scheduledTaskName' should have a last run time on $server ($environment)" {
                    $results.LastRunTime | Should Not BeNullOrEmpty
                }
            }

            if ($results.Error) {
                It "Should not encounter errors on $server ($environment)" {
                    $results.Error | Should BeNullOrEmpty
                }
            }
        }
    }
}

# Invoke the Pester tests
Invoke-Pester
