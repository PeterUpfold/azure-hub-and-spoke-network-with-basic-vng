$VerbosePreference="Continue"

# adapted from https://github.com/MicrosoftDocs/azure-docs/issues/114852#issuecomment-1728303343
$rg = 'RG_NE_HubAndSpoke_Test'
$connectivityNetName = 'vnetHSTestConnectivity'
$location = 'NorthEurope'
$publicIPName = 'pip-HSTestConnectivity-VPN'
$gatewayName = 'vpng-HSTestConnectivity'

$vnet = Get-AzVirtualNetwork -Name $connectivityNetName -ResourceGroupName $rg -Verbose

$subnet = Get-AzVirtualNetworkSubnetConfig -name 'GatewaySubnet' -VirtualNetwork $vnet -Verbose

$ngwpip = @{
    Name = $publicIPName
    ResourceGroupName = $rg
    Location = $location
    Sku = 'Basic'
    AllocationMethod = 'Dynamic'
    IpAddressVersion = 'IPv4'
}
New-AzPublicIpAddress @ngwpip

$ngwpip = Get-AzPublicIpAddress -Name $publicIPName -ResourceGroupName $rg -Verbose

$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig1 -SubnetId $subnet.Id -PublicIpAddressId $ngwpip.Id -Verbose

New-AzVirtualNetworkGateway -Name $gatewayName -ResourceGroupName $rg -Location $location -IpConfigurations $gwipconfig -GatewayType "Vpn" -VpnType "RouteBased" -GatewaySku "Basic" -Verbose
