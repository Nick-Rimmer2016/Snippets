Get-Content -Path "C:\Path\To\File.exe" -Raw | 
Select-String -Pattern '\{[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\}' |
ForEach-Object { $_.Matches.Value }
