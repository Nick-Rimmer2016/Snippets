# Install Reaper Plugins
 
  Start-Process -FilePath C:\obs-install\reaplugs236_x64-install.exe -ArgumentList "/S" -Wait
  
# Uncompress Archive into C:\Users\admin\AppData\Roaming\obs-studio

  Expand-Archive -Path C:\obs-install\obs-studio.zip -DestinationPath C:\Users\$env:username\AppData\Roaming\obs-studio -Force
  
# Amend settings
  
((Get-Content -path C:\Users\admin\AppData\Roaming\obs-studio\basic\profiles\Untitled\basic.ini -Raw) -replace 'D:/techsnip-raw','white') |
 Set-Content -Path C:\Users\admin\AppData\Roaming\obs-studio\basic\profiles\Untitled\basic.ini
