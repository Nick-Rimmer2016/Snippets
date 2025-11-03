<#
.SYNOPSIS
  Open Windows Firewall rules required for running a self-hosted UniFi Network (controller) on Windows.

.NOTES
  - Script attempts to detect java.exe / javaw.exe and add program rules per Ubiquiti guidance.
  - Based on Ubiquiti Required Ports Reference and Windows Firewall KB. See cited docs.
  - Run in an elevated PowerShell session.
#>

# --- Port definitions (from Ubiquiti Required Ports Reference) ---
$inboundPortRules = @(
    @{Name='UniFi - TCP 8080';    Protocol='TCP'; LocalPort='8080'},     # device & application communication
    @{Name='UniFi - TCP 8443';    Protocol='TCP'; LocalPort='8443'},     # GUI/API
    @{Name='UniFi - TCP 8843';    Protocol='TCP'; LocalPort='8843'},     # HTTPS hotspot redirection
    @{Name='UniFi - TCP 8880-8882';Protocol='TCP'; LocalPort='8880-8882'},# HTTP hotpot redirection range
    @{Name='UniFi - TCP 6789';    Protocol='TCP'; LocalPort='6789'},     # mobile speed test
    @{Name='UniFi - TCP 27117';   Protocol='TCP'; LocalPort='27117'},    # local DB
    @{Name='UniFi - UDP 10001';   Protocol='UDP'; LocalPort='10001'},    # device discovery
    @{Name='UniFi - UDP 3478';    Protocol='UDP'; LocalPort='3478'},     # STUN (device adoption/communication)
    @{Name='UniFi - UDP 1900';    Protocol='UDP'; LocalPort='1900'},     # L2 discovery (SSDP/L2)
    @{Name='UniFi - UDP 5514';    Protocol='UDP'; LocalPort='5514'}      # remote syslog capture (if used)
)

# Remote/Other required ports (often both directions or outbound)
# DNS (53) and NTP (123) are commonly required for updates, redirects, and time sync.
$outboundPortRules = @(
    @{Name='UniFi - Outbound DNS 53'; Protocol='UDP'; RemotePort='53'; Direction='Outbound'},
    @{Name='UniFi - Outbound DNS 53 TCP'; Protocol='TCP'; RemotePort='53'; Direction='Outbound'},
    @{Name='UniFi - Outbound NTP 123'; Protocol='UDP'; RemotePort='123'; Direction='Outbound'},
    @{Name='UniFi - Outbound HTTPS 443'; Protocol='TCP'; RemotePort='443'; Direction='Outbound'}
)

# Utility function: create rule if not exists
function Ensure-FirewallRule {
    param(
        [string]$DisplayName,
        [string]$Protocol,
        [string]$LocalPort = $null,
        [string]$RemotePort = $null,
        [ValidateSet('Inbound','Outbound')][string]$Direction = 'Inbound',
        [string]$Program = $null,
        [string]$Description = $null
    )

    # Try to find existing rule
    $existing = Get-NetFirewallRule -DisplayName $DisplayName -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "Rule already exists: $DisplayName"
        return $false
    }

    $params = @{
        DisplayName  = $DisplayName
        Direction    = $Direction
        Action       = 'Allow'
        Enabled      = 'True'
        Profile      = 'Any'
    }

    if ($Protocol) { $params.Protocol = $Protocol }
    if ($LocalPort) { $params.LocalPort = $LocalPort }
    if ($RemotePort) { $params.RemotePort = $RemotePort }
    if ($Program) { $params.Program = $Program }

    try {
        New-NetFirewallRule @params | Out-Null
        Write-Host "Created firewall rule: $DisplayName"
        return $true
    } catch {
        Write-Warning "Failed to create rule $DisplayName : $_"
        return $false
    }
}

# --- Create inbound port rules ---
Write-Host "Adding UniFi inbound port rules..."
foreach ($r in $inboundPortRules) {
    Ensure-FirewallRule -DisplayName $r.Name -Protocol $r.Protocol -LocalPort $r.LocalPort -Direction 'Inbound' -Description "UniFi required port"
}

# --- Create outbound rules (DNS/NTP/HTTPS) ---
Write-Host "Adding UniFi outbound port rules (DNS/NTP/HTTPS)..."
foreach ($r in $outboundPortRules) {
    Ensure-FirewallRule -DisplayName $r.Name -Protocol $r.Protocol -RemotePort $r.RemotePort -Direction $r.Direction -Description "UniFi outbound required port"
}

# --- Add program-based rules for Java (per Ubiquiti Windows KB) ---
Write-Host "Attempting to auto-detect Java (java.exe / javaw.exe) to add program firewall rules..."

$javaPaths = @()

# 1) Check if 'java' is on PATH
try {
    $cmd = Get-Command java.exe -ErrorAction SilentlyContinue
    if ($cmd -and $cmd.Path) { $javaPaths += $cmd.Path }
} catch {}

# 2) Common Adoptium/Eclipse Adoptium default install directories (common on UniFi installs)
$commonPaths = @(
    "${env:ProgramFiles}\Eclipse Adoptium\jre-*\bin\java.exe",
    "${env:ProgramFiles(x86)}\Eclipse Adoptium\jre-*\bin\java.exe",
    "${env:ProgramFiles}\AdoptOpenJDK\*\bin\java.exe",
    "${env:ProgramFiles}\Amazon Corretto\*\bin\java.exe",
    "${env:ProgramFiles}\Zulu\*\bin\java.exe"
)
foreach ($p in $commonPaths) {
    try {
        $found = Get-ChildItem -Path $p -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) { $javaPaths += $found.FullName }
    } catch {}
}

# 3) Check for javaw too
try {
    $cmdW = Get-Command javaw.exe -ErrorAction SilentlyContinue
    if ($cmdW -and $cmdW.Path) { $javaPaths += $cmdW.Path }
} catch {}

# Unique paths
$javaPaths = $javaPaths | Select-Object -Unique

if ($javaPaths.Count -eq 0) {
    Write-Warning "No java.exe/javaw.exe automatically detected. The UniFi KB suggests allowing the Java binaries through the firewall. You can run the script again after installing Java or manually add the program rules. See Ubiquiti KB for guidance."
    Write-Host "Suggested action: locate your java.exe/javaw.exe path (e.g. C:\Program Files\Eclipse Adoptium\jre-11.0.x\bin\java.exe) and run the script function below manually:"
    Write-Host "Example: Ensure-FirewallRule -DisplayName 'UniFi Network Server (Java)' -Protocol TCP -Program 'C:\\Path\\to\\java.exe' -Direction Inbound"
} else {
    foreach ($j in $javaPaths) {
        $display = "UniFi Network Server (Java) - $([IO.Path]::GetFileName($j))"
        # create both TCP and UDP program rules (Ubiquiti KB used both)
        Ensure-FirewallRule -DisplayName $display -Protocol 'TCP' -Program $j -Direction 'Inbound' -Description 'UniFi Java program (TCP)'
        Ensure-FirewallRule -DisplayName $display -Protocol 'UDP' -Program $j -Direction 'Inbound' -Description 'UniFi Java program (UDP)'
    }
}

Write-Host "Finished. Verify in 'Windows Defender Firewall with Advanced Security' > Inbound Rules."
Write-Host "Notes:"
Write-Host " - Ports chosen are from Ubiquiti's Required Ports Reference (device discovery, inform/STUN, GUI/API, hotspot redirection, DB, etc.)." 
Write-Host " - If you changed default ports in UniFi system.properties, update this script accordingly."