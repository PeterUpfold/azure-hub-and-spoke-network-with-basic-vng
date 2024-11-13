<#
.SYNOPSIS
    Connects to the connectivity Vnet and sets DNS policies for accessing private endpoints in each environment network.
#>

# Please see config.example.json for how to specify your configuration.

$ErrorActionPreference="Stop"
$VerbosePreference="Continue"

if (-not (Test-Path 'config.json')) {
    Write-Error "A config.json was not found in this directory. The script cannot run."
    exit 1
}

$Config = (Get-Content 'config.json' | Out-String | ConvertFrom-Json)
Write-Verbose $Config.VPNConfigurationName

$vpn = Get-VpnConnection -Name $Config.VPNConfigurationName

if (-not $vpn) {
    Write-Error "The VPN configuration $($Config.VPNConfigurationName) does not exist."
}

if ($vpn.ConnectionStatus -eq "Disconnected") {
    Write-Verbose "Calling rasdial.exe to connect to VPN..."
    rasdial.exe $Config.VPNConfigurationName
}

foreach($rule in $Config.DNSClientNRPTRules) {
    Write-Verbose "Adding DNS client rule for $rule"
    Add-DnsClientNrptRule -Namespace $rule -NameServers $Config.DNSServer -DisplayName "$($Config.VPNConfigurationName)-$rule" -Verbose
}
