# Resourcegroups deployments
# Make sure to have Owner priviledge level in Azure to deploy the Resource Groups as locking requires Owner's level access. To increase level go to:
# https://portal.azure.com/#blade/Microsoft_Azure_PIM/CrossProviderActivationMenuBlade/azureResourceRoles/isAADGroupVisible//isAADRbacVisible/

Param(
    [string]$configFilePath = "$PSScriptRoot\settings.xml"
)

$ErrorActionPreference = "Stop"

$configFilePath = Resolve-Path $configFilePath

# sign in
#Write-Host "Logging in...";
if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    Write-Host "You need to login. Minimize the Visual Studio Code and login to the window that poped-up"
    Login-AzureRmAccount
}

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

.\scripts\deploysubv2.ps1 -configFilePath $configFilePath -templateLibraryName resourcegroups/20190207.2 -parametersFileName .\deploy-10-resourcegroups-canadacentral.parameters.json

# Route Tables Deployments
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-core.parameters.json -AsJob -resourceGroupName Demo-Infra-NetCore-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-mgmt-rds.parameters.json -AsJob -resourceGroupName Demo-Infra-NetMGMT-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-mgmt-test.parameters.json -AsJob -resourceGroupName Demo-Infra-NetMGMT-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-mgmt-ad.parameters.json -AsJob -resourceGroupName Demo-Infra-NetMGMT-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-mgmt-mgmttocore.parameters.json -AsJob -resourceGroupName Demo-Infra-NetMGMT-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-shared-ad.parameters.json -AsJob -resourceGroupName Demo-Infra-NetShared-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-shared-crm.parameters.json -AsJob -resourceGroupName Demo-Infra-NetShared-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-shared-sandbox.parameters.json -AsJob -resourceGroupName Demo-Infra-NetShared-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-shared-rds.parameters.json -AsJob -resourceGroupName Demo-Infra-NetShared-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-shared-sharedtocore.parameters.json -AsJob -resourceGroupName Demo-Infra-NetShared-RG
Write-Host "Waiting for parallel routes jobs to finish..."

# Wait for all jobs to complete
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the routes was not successfully created... exiting..."
    exit
}

# Display all jobs output
Get-Job | Receive-Job

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

# Keyvault deployment
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName keyvaults/20190302.1 -parametersFileName .\deploy-40-keyvaults.parameters.json -resourceGroupName Demo-Infra-Keyvault-RG -AsJob 

# VNET and Subnet deployment
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-subnet/20190302.2 -parametersFileName .\deploy-20-vnet-subnet-core.parameters.json -resourceGroupName Demo-Infra-NetCore-RG -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-subnet/20190302.2 -parametersFileName .\deploy-20-vnet-subnet-mgmt.parameters.json -resourceGroupName Demo-Infra-NetMgmt-RG -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-subnet/20190302.2 -parametersFileName .\deploy-20-vnet-subnet-shared.parameters.json -resourceGroupName Demo-Infra-NetShared-RG -AsJob

Write-Host "Waiting for parallel keyvaults & vnet jobs to finish..."

# Wait for all jobs to complete
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the keyvaults or vnet was not successfully created... exiting..."
    exit
}

# Display all jobs output
Get-Job | Receive-Job

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-peering/20190302.2 -parametersFileName .\deploy-30-vnet-peering-core.parameters.json -resourceGroupName Demo-Infra-NetCore-RG -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-peering/20190302.2 -parametersFileName .\deploy-30-vnet-peering-mgmt.parameters.json -resourceGroupName Demo-Infra-NetMgmt-RG -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-peering/20190302.2 -parametersFileName .\deploy-30-vnet-peering-shared.parameters.json -resourceGroupName Demo-Infra-NetShared-RG -AsJob

Write-Host "Waiting for parallel vnet-peering jobs to finish..."

# Wait for all jobs to complete
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the vnet peering jobs did not successfully execute... exiting..."
    exit
}

# Display all jobs output
Get-Job | Receive-Job

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

# Firewall deployments (Marketplace need to be open)
# Accept Terms of BYOL
#Get-AzureRmMarketplaceTerms -Publisher fortinet -Product fortinet_fortigate-vm_v5 -Name fortinet_fg-vm | Set-AzureRmMarketplaceTerms -Accept

# Deploy firewalls
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName fortigate/20190312.1 -parametersFileName .\deploy-50-fortigate-core.parameters.json -resourceGroupName Demo-Infra-FWCore-RG -deploymentName "core-fortigate" -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName fortigate4NIC/20190312.1 -parametersFileName .\deploy-50-fortigate-mgmt.parameters.json -resourceGroupName Demo-Infra-FWMGMT-RG -deploymentName "mgmt-fortigate" -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName fortigate4NIC/20190312.1 -parametersFileName .\deploy-50-fortigate-shrd.parameters.json -resourceGroupName Demo-Infra-FWShared-RG -deploymentName "shared-fortigate" -AsJob


# vmdiag storage for servers
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName storage/20190302.2 -parametersFileName .\deploy-55-storage.parameters.json -resourceGroupName Demo-MGMT-RDS-RG

# Jumpbox Server Deployments
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName servers/20190302.1 -parametersFileName .\deploy-60-servers.parameters.json -resourceGroupName Demo-MGMT-RDS-RG

Write-Host "Waiting for parallel jobs to finish..."
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the cisco asav resource was not successfully created... exiting..."
    exit
}

# Display all jobs output
Get-Job | Receive-Job

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

$corePUBLICip = (Get-AzureRmResourceGroupDeployment -ResourceGroupName Demo-Infra-FWCore-RG -Name "core-fortigate").Outputs.publicIP.value

Write-Host "There was no deployment errors detected. All look good."
$fwURL = "https://$corePUBLICip" + ":8443"
$dockerURL = "http://$corePUBLICip" + ":8080"
$RDPAddress = $corePUBLICip + ":33891"

Write-Host "There was no deployment errors detected. All look good."
Write-Host "Connect to the Core firewall using a web browser and connect to $fwURL"
Write-Host "Connect to the demo website using a web browser and connect to $dockerURL"
Write-Host "Connect to the Jumpbox01 using RDP to $RDPAddress"

.\deploy-docker.ps1