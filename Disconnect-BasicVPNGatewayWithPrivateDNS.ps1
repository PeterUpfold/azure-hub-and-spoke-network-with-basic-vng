
<#
.SYNOPSIS
    Disconnects from the connectivity Vnet and removes DNS policies for accessing private endpoints in each environment network.
#>

# Please see config.example.json for how to specify your configuration.

$ErrorActionPreference="Stop"
$VerbosePreference="Continue"

if (-not (Test-Path 'config.json')) {
    Write-Error "A config.json was not found in this directory. The script cannot run."
    exit 1
}

$Config = (Get-Content 'config.json' | Out-String | ConvertFrom-Json)

foreach($rule in $Config.DNSClientNRPTRules) {
    Write-Verbose "Tidying DNS client rule $rule"
    Get-DnsClientNrptRule | Where-Object -Property DisplayName -EQ "$($Config.VPNConfigurationName)-$rule" | Remove-DnsClientNrptRule -Force -Verbose
}

Write-Verbose "Calling rasdial.exe to disconnect from $($Config.VPNConfigurationName)"
rasdial.exe $Config.VPNConfigurationName /disconnect