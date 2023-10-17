# Folder to watch
$folder = 'C:\Path\To\Watched\Folder'

# Filter for file types to watch (use * for all types)
$filter = '*.*'

# Time to wait before running another script (in seconds)
$timeout = 30

# Initialize FileSystemWatcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folder
$watcher.Filter = $filter
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# Initialize a timer
$timer = New-Object Timers.Timer
$timer.Interval = ($timeout * 1000)

# Register timer elapsed event
$timerElapsed = Register-ObjectEvent -InputObject $timer -EventName Elapsed -Action {
    Write-Host "No activity detected for $timeout seconds. Running AnotherScript.ps1"
    .\AnotherScript.ps1
    # Exit the script
    Exit
}

# Start the timer
$timer.Start()

# Register events for the watcher
$action = {
    $global:timer.Stop()
    $global:timer.Start()
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    Write-Host "File $path was $changeType at $(Get-Date)"
}

$fileWatcherAction = Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action

# Wait for the timer or an event to trigger
Wait-Event -SourceIdentifier $timerElapsed.Name

# Unregister event and dispose of timer and watcher
Unregister-Event -SourceIdentifier $timerElapsed.Name
$timer.Dispose()
$watcher.Dispose()
