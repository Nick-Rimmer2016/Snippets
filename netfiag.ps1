<# 
.SYNOPSIS
  Network connectivity troubleshooting script for Windows laptops.

.DESCRIPTION
  Collects system and network details, checks interfaces, DNS, default gateways, 
  pings key targets, tests ports, traces routes, inspects proxy + firewall settings,
  and performs a captive-portal check. Outputs everything to a UTF-8 text file.

.PARAMETER OutputPath
  Optional path to the output .txt file. If omitted, a timestamped file is created on Desktop.

.EXAMPLE
  .\Network-Diag.ps1
  .\Network-Diag.ps1 -OutputPath "C:\Temp\MyNetDiag.txt"
#>

[CmdletBinding()]
param(
  [string]$OutputPath
)

# --------------------------- Setup ---------------------------
$ErrorActionPreference = 'Continue'
$startTime = Get-Date

if (-not $OutputPath) {
  $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
  $OutputPath = Join-Path $env:USERPROFILE "Desktop\NetDiag_$($env:COMPUTERNAME)_$stamp.txt"
}

# Use a StringBuilder for speed
$sb = New-Object System.Text.StringBuilder
function Add-Line($text='') { [void]$sb.AppendLine($text) }
function Add-Section($title) {
  Add-Line( ('=' * 80) )
  Add-Line( ">>> $title" )
  Add-Line( ('=' * 80) )
}

# Helper to run a scriptblock and capture output + errors as string
function Capture([scriptblock]$Block) {
  try {
    & $Block | Out-String
  } catch {
    "ERROR: $($_.Exception.Message)`n"
  }
}

# Helper to run external exe safely and capture output
function Run-Exe($file, $args) {
  try {
    & $file @args 2>&1 | Out-String
  } catch {
    "ERROR running $file $args : $($_.Exception.Message)`n"
  }
}

# Safe Resolve-DnsName with fallback to nslookup
function Safe-Resolve([string]$Name) {
  try {
    if (Get-Command Resolve-DnsName -ErrorAction SilentlyContinue) {
      Resolve-DnsName -Name $Name -ErrorAction Stop | Select-Object Name,Type,IPAddress,Section | Format-Table -Auto | Out-String
    } else {
      Run-Exe nslookup $Name
    }
  } catch {
    "DNS resolution failed for $Name : $($_.Exception.Message)`n"
  }
}

# Quick ping helper
function Ping-Host([string]$Target, [int]$Count = 2) {
  try {
    if (Get-Command Test-Connection -ErrorAction SilentlyContinue) {
      Test-Connection -Count $Count -Quiet -ErrorAction Stop -TargetName $Target
    } else {
      $out = Run-Exe ping @("$Target","-n",$Count)
      return ($out -match 'TTL=')
    }
  } catch { $false }
}

# --------------------------- System Info ---------------------------
Add-Section "System"
Add-Line "Computer Name : $env:COMPUTERNAME"
Add-Line "User          : $env:USERNAME"
Add-Line "OS            : $( (Get-CimInstance Win32_OperatingSystem).Caption ) $( (Get-CimInstance Win32_OperatingSystem).Version )"
Add-Line "PowerShell    : $($PSVersionTable.PSVersion.ToString()) ($([Environment]::Is64BitProcess ? 'x64' : 'x86'))"
Add-Line "Started       : $startTime"
Add-Line

# --------------------------- Network Adapters & IP ---------------------------
Add-Section "Network Adapters & IP Configuration"
Add-Line (Capture { Get-NetAdapter | Sort-Object Status,Name | Format-Table -Auto Name, InterfaceDescription, Status, LinkSpeed, MacAddress })
Add-Line
Add-Line (Capture { Get-NetIPConfiguration | Format-List })
Add-Line

# Wi-Fi details (SSID, signal)
Add-Section "Wi-Fi (if applicable)"
Add-Line (Run-Exe netsh @('wlan','show','interfaces'))

# --------------------------- DNS & Gateway ---------------------------
Add-Section "DNS Servers"
Add-Line (Capture { Get-DnsClientServerAddress -AddressFamily IPv4,IPv6 | Sort-Object InterfaceAlias | Format-Table -Auto InterfaceAlias, ServerAddresses })
Add-Line

Add-Section "Default Gateways"
try {
  $gateways = Get-NetIPConfiguration | ForEach-Object { $_.IPv4DefaultGateway.NextHop; $_.IPv6DefaultGateway.NextHop } | Where-Object { $_ }
  if (-not $gateways) { Add-Line "No default gateway detected." }
  else { $gateways | ForEach-Object { Add-Line $_ } }
} catch { Add-Line "Failed to enumerate gateways: $($_.Exception.Message)" }
Add-Line

# --------------------------- Proxy ---------------------------
Add-Section "Proxy Configuration"
Add-Line "WinHTTP proxy:"
Add-Line (Run-Exe 'netsh' @('winhttp','show','proxy'))
Add-Line
Add-Line "User (WinINet/IE/Edge legacy) proxy:"
try {
  $k = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
  $enabled = (Get-ItemProperty -Path $k -Name ProxyEnable -ErrorAction SilentlyContinue).ProxyEnable
  $server  = (Get-ItemProperty -Path $k -Name ProxyServer -ErrorAction SilentlyContinue).ProxyServer
  Add-Line "ProxyEnable=$enabled"
  Add-Line "ProxyServer=$server"
} catch { Add-Line "Could not read user proxy settings: $($_.Exception.Message)" }
Add-Line
Add-Line "Proxy-related environment variables:"
$envNames = 'HTTP_PROXY','HTTPS_PROXY','NO_PROXY','http_proxy','https_proxy','no_proxy'
foreach ($n in $envNames) { if ($env:$n) { Add-Line "$n=$($env:$n)" } }
Add-Line

# --------------------------- Firewall ---------------------------
Add-Section "Windows Firewall Profiles"
Add-Line (Capture { Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction | Format-Table -Auto })

# --------------------------- Routing ---------------------------
Add-Section "Routing Table"
if (Get-Command Get-NetRoute -ErrorAction SilentlyContinue) {
  Add-Line (Capture { Get-NetRoute | Sort-Object DestinationPrefix | Format-Table -Auto DestinationPrefix, NextHop, InterfaceAlias, RouteMetric })
} else {
  Add-Line (Run-Exe route @('print'))
}
Add-Line

# --------------------------- Connectivity Tests ---------------------------
Add-Section "Connectivity Summary (quick)"
$targets = [ordered]@{
  "Gateway" = ($gateways | Select-Object -First 1)
  "DNS-1.1.1.1" = "1.1.1.1"
  "DNS-8.8.8.8" = "8.8.8.8"
  "Domain-bing.com" = "bing.com"
  "Domain-github.com" = "github.com"
}
$summary = @{}
foreach ($k in $targets.Keys) {
  $t = $targets[$k]
  if ([string]::IsNullOrWhiteSpace($t)) { $summary[$k] = $false; continue }
  $ok = Ping-Host -Target $t
  $summary[$k] = [bool]$ok
}
$summary.GetEnumerator() | ForEach-Object {
  Add-Line ("{0,-20} : {1}" -f $_.Key, ($(if ($_.Value) { 'PASS' } else { 'FAIL' })))
}
Add-Line

Add-Section "Test-NetConnection (detailed)"
function TNC($dest, [int]$port = 0, [switch]$Trace) {
  try {
    if ($port -gt 0 -and $Trace) {
      Test-NetConnection -ComputerName $dest -Port $port -InformationLevel Detailed -TraceRoute | Out-String
    } elseif ($port -gt 0) {
      Test-NetConnection -ComputerName $dest -Port $port -InformationLevel Detailed | Out-String
    } elseif ($Trace) {
      Test-NetConnection -ComputerName $dest -InformationLevel Detailed -TraceRoute | Out-String
    } else {
      Test-NetConnection -ComputerName $dest -InformationLevel Detailed | Out-String
    }
  } catch {
    "Test-NetConnection failed for $dest (port $port): $($_.Exception.Message)`n"
  }
}

Add-Line "ICMP reachability:"
foreach ($t in @('1.1.1.1','8.8.8.8','bing.com','github.com')) {
  Add-Line "---- $t ----"
  Add-Line (TNC $t)
}

Add-Line "TCP 80/443 checks:"
foreach ($t in @('www.microsoft.com','www.github.com','www.google.com')) {
  foreach ($p in 80,443) {
    Add-Line "---- $t : TCP $p ----"
    Add-Line (TNC $t $p)
  }
}

# DNS port 53 reachability to detected DNS servers
Add-Line "DNS (UDP/TCP 53) checks to local DNS servers:"
try {
  $dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses + (Get-DnsClientServerAddress -AddressFamily IPv6).ServerAddresses
  $dnsServers = $dnsServers | Where-Object { $_ } | Select-Object -Unique
  foreach ($s in $dnsServers) {
    Add-Line "---- $s : TCP 53 ----"
    Add-Line (TNC $s 53)
  }
} catch {
  Add-Line "Failed to enumerate DNS servers: $($_.Exception.Message)"
}

# --------------------------- DNS Resolution ---------------------------
Add-Section "DNS Resolution Tests"
foreach ($name in @('bing.com','github.com','microsoft.com','cloudflare.com')) {
  Add-Line "---- $name ----"
  Add-Line (Safe-Resolve $name)
}

# --------------------------- Traceroutes ---------------------------
Add-Section "Traceroute"
Add-Line "To 1.1.1.1"
if (Get-Command Test-NetConnection -ErrorAction SilentlyContinue) {
  Add-Line (TNC '1.1.1.1' 0 -Trace)
} else {
  Add-Line (Run-Exe tracert @('1.1.1.1'))
}
Add-Line
Add-Line "To github.com"
if (Get-Command Test-NetConnection -ErrorAction SilentlyContinue) {
  Add-Line (TNC 'github.com' 0 -Trace)
} else {
  Add-Line (Run-Exe tracert @('github.com'))
}
Add-Line

# --------------------------- Captive Portal Check ---------------------------
Add-Section "Captive Portal Check"
try {
  $uri = 'http://www.msftconnecttest.com/connecttest.txt'
  $r = Invoke-WebRequest -Uri $uri -TimeoutSec 6 -UseBasicParsing
  if ($r.StatusCode -eq 200 -and ($r.Content -match 'Microsoft')) {
    Add-Line "Open internet likely available (received expected response from $uri)."
  } else {
    Add-Line "Unexpected response from $uri. Possible captive portal or content filter."
  }
} catch {
  Add-Line "Request failed: $($_.Exception.Message). Possible captive portal, DNS, or firewall issue."
}
Add-Line

# --------------------------- Recent Network Events (optional) ---------------------------
Add-Section "Recent Network-Related Events (last 2 hours)"
try {
  $since = (Get-Date).AddHours(-2)
  $events = Get-WinEvent -FilterHashtable @{ LogName = 'System'; StartTime = $since; ProviderName = @(
      'Microsoft-Windows-NDIS',
      'Microsoft-Windows-WLAN-AutoConfig',
      'Tcpip',
      'NETLOGON',
      'DnsApi'
    )} -ErrorAction SilentlyContinue | Select-Object TimeCreated, ProviderName, Id, LevelDisplayName, Message
  if ($events) {
    $events | Format-Table -Auto | Out-String | ForEach-Object { Add-Line $_ }
  } else {
    Add-Line "No recent events or access denied."
  }
} catch {
  Add-Line "Could not read events: $($_.Exception.Message)"
}
Add-Line

# --------------------------- Finish ---------------------------
$endTime = Get-Date
Add-Section "Run Summary"
Add-Line "Started : $startTime"
Add-Line "Ended   : $endTime"
Add-Line "Elapsed : $([int]($endTime - $startTime).TotalSeconds) seconds"
Add-Line
Add-Line "Quick PASS/FAIL:"
$summary.GetEnumerator() | ForEach-Object {
  Add-Line ("{0,-20} : {1}" -f $_.Key, ($(if ($_.Value) { 'PASS' } else { 'FAIL' })))
}
Add-Line
Add-Line "Output saved to: $OutputPath"

# Write to disk
$sb.ToString() | Set-Content -Path $OutputPath -Encoding UTF8

# Also echo where we saved it
Write-Host "Network diagnostics written to: $OutputPath"