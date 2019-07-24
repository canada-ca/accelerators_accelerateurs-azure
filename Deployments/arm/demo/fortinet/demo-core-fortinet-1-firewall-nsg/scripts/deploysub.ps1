# Resourcegroups deployments
# Make sure to have Owner priviledge level in Azure to deploy the Resource Groups as locking requires Owner's level access. To increase level go to:
# https://portal.azure.com/#blade/Microsoft_Azure_PIM/CrossProviderActivationMenuBlade/azureResourceRoles/isAADGroupVisible//isAADRbacVisible/

Param(
    [Parameter(Mandatory=$True)][string]$parameterFile = "",
    [string]$subscriptionId = "",
    [string]$storageRG = "Demo-Infra-Storage-RG",
    [string]$storageAccountName = "deployments",
    #[string]$containerName = "deployments",
    [string]$location = "canadacentral"
)

function Output-DeploymentName {
    param( [string]$Name)

    $pattern = '[^a-zA-Z0-9-]'

    # Remove illegal characters from deployment name
    $Name = $Name -replace $pattern, ''

    # Truncate deplayment name to 64 characters
    $Name.subString(0, [System.Math]::Min(64, $Name.Length))
}
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

$deploymentName = Output-DeploymentName($parameterFile)
$containerName = $deploymentName

# sign in
#Write-Host "Logging in...";
if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    Write-Host "You need to login. Minimize the Visual Studio Code and login to the window that poped-up"
    Login-AzureRmAccount
}

if (![string]::IsNullOrEmpty($subscriptionId)) {
    Select-AzureRmSubscription -Subscription $subscriptionId
}

Write-Host "Copying parameters files for deployment to https://$deploymentStorageAccountName.blob.core.windows.net/$containerName"

& (Resolve-Path -Path "$PSScriptRoot\upload-parameters-files.ps1") -containerName $containerName

Write-Host "Starting base infrastructure deployment..."

# Get storageaccount name that contains parameters files
$deploymentStorageAccountName = (Get-AzureRmResourceGroupDeployment -ResourceGroupName $storageRG -Name "storageAccount.$storageAccountName").Outputs.storageAccountName.value

$null = Set-AzureRmCurrentStorageAccount -ResourceGroupName $storageRG -Name $deploymentStorageAccountName

# Create the SaS token for the contrainer
$token = New-AzureStorageContainerSASToken -Name $containerName -Permission r -ExpiryTime (Get-Date).AddMinutes(60.0)

# Deploy infrastructure dependencies
New-AzureRmDeployment -Location $Location -Name "Deploy-$deploymentName" -TemplateUri "https://raw.githubusercontent.com/canada-ca/accelerators_accelerateurs-azure/master/Templates/arm/masterdeploy/20190319.1/masterdeploysub.json" -TemplateParameterFile (Resolve-Path -Path $parameterFile) -baseParametersURL "https://$deploymentStorageAccountName.blob.core.windows.net/$containerName/" -parametersSasToken $token -Verbose;
