@echo off

setlocal

set "sourcePath=C:\local\path"
set "destinationPath=\\server\share\path"
set "logFile=C:\path\to\log\robocopy.log"

robocopy "%sourcePath%" "%destinationPath%" /MIR /NP /LOG:"%logFile%"

set "exitCode=%errorlevel%"

if %exitCode% equ 0 (
    echo Robocopy completed successfully.
) else if %exitCode% equ 1 (
    echo Robocopy completed with one or more files copied.
) else (
    echo An error occurred during Robocopy. Exit code: %exitCode%.
)

endlocal
