.\scripts\deployrgv2.ps1 -templateLibraryName active-directory/20190314.7 -parametersFileName .\deploy-20-adds.parameters.json -templateName azuredeploy.json -resourceGroupName Demo-MGMT-ADDS-RG
.\scripts\deployrgv2.ps1 -templateLibraryName servers-encryptVMDisks/20190314.4 -parametersFileName .\deploy-60-encryptVMDisk.parameters.json -resourceGroupName Demo-MGMT-ADDS-RG
# next step manually change DNS on subnets withing the management infrastructure

Write-Host "You can RDP to the Active Directory servers at 10.25.8.20 an 10.25.8.21"

<#
next step manually add the following dhcp option to the management vnet and redeploy it to Azure:

"dhcpOptions":  {
    "dnsServers": [
        "10.25.8.20",
        "10.25.8.21"
    ]
},

#>