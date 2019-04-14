# Resourcegroups deployments
# Make sure to have Owner priviledge level in Azure to deploy the Resource Groups as locking requires Owner's level access. To increase level go to:
# https://portal.azure.com/#blade/Microsoft_Azure_PIM/CrossProviderActivationMenuBlade/azureResourceRoles/isAADGroupVisible//isAADRbacVisible/

Param(
    [string]$configFilePath = "$PSScriptRoot\settings.xml"
)

function Cleanup {
    Remove-Item -Path $tempDirName\register.ios
    exit
}

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

$ErrorActionPreference = "Stop"

$configFilePath = Resolve-Path $configFilePath
$tempDirName = New-TemporaryDirectory
$idtoken = "none"
$tempDirName = $tempDirName.ToString()

# Insert cisco smartlicense token to obtain license during deployment
$confirmation = Read-Host "Do you want to license the cisco asav firewall during deployment (y/n)"
if ($confirmation -eq 'y') {
    $idtoken = Read-Host "Type in the smartlicense to use. Need to be good for 3 licenses"
} else {
    Write-Host "Since you opted not to license the ASAv I will not deploy the demo web server due to lack of throughput on the ASAv that would result if a deployment failure..."
}
((Get-Content -path $PSScriptRoot\ciscoasav\register.ios.template -raw) -replace '\[idtoken\]', $idtoken) | Set-Content -Path $tempDirName\register.ios

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
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-mgmt.parameters.json -AsJob -resourceGroupName Demo-Infra-NetMGMT-RG
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName routes/20190301.3 -parametersFileName .\deploy-15-routes-shared.parameters.json -AsJob -resourceGroupName Demo-Infra-NetShared-RG
Write-Host "Waiting for parallel routes jobs to finish..."

# Wait for all jobs to complete
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the routes was not successfully created... exiting..."
    Cleanup
}

# Display all jobs output
Get-Job | Receive-Job

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

# Keyvault deployment
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName keyvaults/20190302.1 -parametersFileName .\deploy-40-keyvaults.parameters.json -resourceGroupName Demo-Infra-Keyvault-RG -AsJob 

# NSG deployment
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName nsg/20190313.1 -parametersFileName .\deploy-17-nsg-shared.parameters.json -resourceGroupName Demo-Infra-NetShared-RG -AsJob

# vmdiag storage for servers
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName storage/20190302.2 -parametersFileName .\deploy-55-storage.parameters.json -resourceGroupName Demo-MGMT-RDS-RG -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName storage/20190302.2 -parametersFileName .\deploy-55-storage.parameters.json -resourceGroupName Demo-Shared-Sandbox-RG -AsJob

Write-Host "Waiting for parallel keyvaults, NSG and storage jobs to finish..."

# Wait for all jobs to complete
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the parallel keyvaults, NSG or storage was not successfully created... exiting..."
    Cleanup
}

# Display all jobs output
Get-Job | Receive-Job

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

# VNET and Subnet deployment
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-subnet/20190313.1 -parametersFileName .\deploy-20-vnet-subnet-core.parameters.json -resourceGroupName Demo-Infra-NetCore-RG -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-subnet/20190313.1 -parametersFileName .\deploy-20-vnet-subnet-mgmt.parameters.json -resourceGroupName Demo-Infra-NetMgmt-RG -AsJob
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName vnet-subnet/20190313.1 -parametersFileName .\deploy-20-vnet-subnet-shared.parameters.json -resourceGroupName Demo-Infra-NetShared-RG -AsJob

Write-Host "Waiting for parallel vnet jobs to finish..."

# Wait for all jobs to complete
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the vnet was not successfully created... exiting..."
    Cleanup
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
    Cleanup
}

# Display all jobs output
Get-Job | Receive-Job

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

# Firewall deployments (Marketplace need to be open)
# Accept Terms of BYOL
#Get-AzureRmMarketplaceTerms -Publisher cisco -Product cisco-asav -Name asav-azure-byol | Set-AzureRmMarketplaceTerms -Accept

.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName ciscoasav2NIC/20190303.12 -parametersFileName .\deploy-50-ciscoasav-core.parameters.json -resourceGroupName Demo-Infra-FWCore-RG -deploymentName "core-cisco-asav" -AsJob

Write-Host "Waiting for parallel Cisco ASAv firewall jobs to finish..."
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the cisco asav resource was not successfully created... exiting..."
    Cleanup
}

# Display all jobs output
Get-Job | Receive-Job

# Cleanup old jobs before running new deployments
Get-Job | Remove-Job

$coreASAPIBLICip = (Get-AzureRmResourceGroupDeployment -ResourceGroupName Demo-Infra-FWCore-RG -Name "core-cisco-asav").Outputs.publicIP.value

#Configure cisco ASAv firewall. UGLY but work for now
cmd /c echo "y" | .\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m .\ciscoasav\core-base-config.ios $coreASAPIBLICip
.\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m .\ciscoasav\core-base-config.ios $coreASAPIBLICip
Start-Sleep -Seconds 5
.\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m $tempDirName\register.ios $coreASAPIBLICip

# Jumpbox Server Deployments
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName servers/20190307.1 -parametersFileName .\deploy-60-servers.parameters.json -resourceGroupName Demo-MGMT-RDS-RG -AsJob

if ($confirmation -eq 'y') {
    # Web Server Deployments
    .\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName servers/20190307.1 -parametersFileName .\deploy-61-servers.parameters.json -resourceGroupName Demo-Shared-Sandbox-RG -AsJob
}

# Wait for all jobs to complete
Get-Job | Wait-Job

if (Get-Job -State Failed) {
    Write-Host "One of the jobs did not successfully execute... exiting..."
    Cleanup
}


$dockerURL = "http://$coreASAPIBLICip"
$RDPAddress = $coreASAPIBLICip + ":3389"

Write-Host "There was no deployment errors detected. All look good."
Write-Host
Write-Host "Connect to the Core firewall using ASDM to $coreASAPIBLICip"
Write-Host "Connect to the demo website using a web browser at $dockerURL"
Write-Host "Connect to the temporary Jumpbox server using RDP to $RDPAddress"