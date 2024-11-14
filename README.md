# azure-hub-and-spoke-network-with-basic-vng

Scripts and configurations for an Azure hub and spoke network topology using private links and a basic Virtual Network Gateway.

These scripts accompany my blog post on the topic: https://peter.upfold.org.uk/blog/2024/11/13/accessing-resources-via-private-endpoint-in-azure-hub-and-spoke-virtual-network-with-basic-sku-vpn-gateway/

# Scripts

## New-BasicVPNGateway.ps1

Azure PowerShell: creates a Virtual Network Gateway using the Basic SKU, which is not exposed by the Azure Portal UI.

## Connect-BasicVPNGatewayWithPrivateDNS.ps1

Connect to a basic VPN connection and set DNS NRPT rules to pass the specified domains (configured in config.json)
to a private DNS server inside the VPN network. This facilitates looking up the private endpoints for the Azure
resources that are inside the vnet.

## Disconnect-BasicVPNGatewayWithPrivateDNS.ps1

Disconnects from the connection and tidies up the DNS NRPT rules created by the connect script.

# Licence

Apache 2.0. Please see LICENSE.