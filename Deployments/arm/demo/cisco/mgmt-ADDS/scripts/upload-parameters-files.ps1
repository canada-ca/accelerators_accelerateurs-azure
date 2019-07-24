Param(
    [string]$templateLibrarySrc = "$PSScriptRoot\..\parameters\",
    [string]$storageRG = "Demo-Infra-Storage-RG",
    [string]$location = "canadacentral",
    [string]$storageAccountName = "deployments",
    [string]$containerName = "library",
    [string]$subscriptionId = "",
    [string]$parametersFileName = "deploy-0-storage.json"
)

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# sign in
#Write-Host "Logging in...";
if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    Write-Host "You need to login. Minimize the Visual Studio Code and login to the window that poped-up"
    Login-AzureRmAccount
}

if (![string]::IsNullOrEmpty($subscriptionId)) {
    Select-AzureRmSubscription -Subscription $subscriptionId
}

$resolvedParametersFileName = Resolve-Path -Path "$PSScriptRoot\..\parameters\$parametersFileName"
$resolvedTemplateLibrarySrc = Resolve-Path -Path $templateLibrarySrc

#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $storageRG -ErrorAction SilentlyContinue

if(!$resourceGroup)
{
    Write-Host "Resource group '$storageRG' does not exist. To create a new resource group, please enter a location.";

    Write-Host "Creating resource group '$storageRG' in location '$location'";
    New-AzureRmResourceGroup -Name $storageRG -Location $location

    #Write-Host "Creating storage account in resourcegroup '$storageRG'";
    #New-AzureRmResourceGroupDeployment -ResourceGroupName $storageRG -Name Create-Deployment-Storage-Account -TemplateUri "https://raw.githubusercontent.com/canada-ca/accelerators_accelerateurs-azure/master/Templates/arm/storage/20190317.1/azuredeploy.json" -TemplateParameterFile $resolvedParametersFileName -Verbose
}
else{
    Write-Host "Using existing resource group '$storageRG'";
}

Write-Host "Checking if storageAccount.$storageAccountName exist in resourceGroupName $storageRG"
$deploymentStorageAccountName = (Get-AzureRmResourceGroupDeployment -ResourceGroupName $storageRG -Name "storageAccount.$storageAccountName" -ErrorVariable notPresent -ErrorAction SilentlyContinue).Outputs.storageAccountName.value

if ($notPresent) {
    Write-Host "Creating storage account $storageAccountName in resourcegroup '$storageRG'";
    New-AzureRmResourceGroupDeployment -ResourceGroupName $storageRG -Name Create-Deployment-Storage-Account -TemplateUri "https://raw.githubusercontent.com/canada-ca/accelerators_accelerateurs-azure/master/Templates/arm/storage/20190317.1/azuredeploy.json" -TemplateParameterFile $resolvedParametersFileName -Verbose
    $deploymentStorageAccountName = (Get-AzureRmResourceGroupDeployment -ResourceGroupName $storageRG -Name "storageAccount.$storageAccountName" -ErrorVariable notPresent -ErrorAction SilentlyContinue).Outputs.storageAccountName.value
}

$templateBlobDest = "https://$deploymentStorageAccountName.blob.core.windows.net/$containerName/"
$destKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storageRG -AccountName $deploymentStorageAccountName).Value[0]

# Important step to expand the received path to the library to a fully qualified path
$templateLibrarySrc = Resolve-Path $templateLibrarySrc

Write-Host "Copying folder $resolvedTemplateLibrarySrc to $templateBlobDest"

AzCopy /Source:$resolvedTemplateLibrarySrc /Dest:$templateBlobDest /DestKey:$destKey /S /Y