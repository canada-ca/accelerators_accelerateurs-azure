# Resourcegroups deployments
# Make sure to have Owner priviledge level in Azure to deploy the Resource Groups as locking requires Owner's level access. To increase level go to:
# https://portal.azure.com/#blade/Microsoft_Azure_PIM/CrossProviderActivationMenuBlade/azureResourceRoles/isAADGroupVisible//isAADRbacVisible/

Param(
    [string]$storageRG = "Demo-Infra-Storage-RG",
    [string]$storageAccountName = "deployments",
    [string]$containerName = "deployments",
    [string]$location = "canadacentral",
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
$confirmation = Read-Host "Do you have license for the fortigate firewall (y/n)"
if ($confirmation -eq 'n') {
    Write-Host "Since you do not have license the fortigate firewall the demo web server will not be deployed..."
}

# sign in
#Write-Host "Logging in...";
if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    Write-Host "You need to login. Minimize the Visual Studio Code and login to the window that poped-up"
    Login-AzureRmAccount
}

Write-Host "Copying parameters files for deployment to https://$deploymentStorageAccountName.blob.core.windows.net/deployments"

& (Resolve-Path -Path "$PSScriptRoot\scripts\upload-parameters-files.ps1")

Write-Host "Starting base infrastructure deployment..."

# Get storageaccount name that contains parameters files
$deploymentStorageAccountName = (Get-AzureRmResourceGroupDeployment -ResourceGroupName $storageRG -Name "storageAccount.$storageAccountName").Outputs.storageAccountName.value

$null = Set-AzureRmCurrentStorageAccount -ResourceGroupName $storageRG -Name $deploymentStorageAccountName

# Create the SaS token for the contrainer
$token = New-AzureStorageContainerSASToken -Name $containerName -Permission r -ExpiryTime (Get-Date).AddMinutes(90.0)

# Deploy base infrastructure
New-AzureRmDeployment -Location $Location -Name Base-Infrastructure -TemplateUri "https://azpwsdeployment.blob.core.windows.net/library/arm/masterdeploy/20190319.1/masterdeploysubrg.json" -TemplateParameterFile (Resolve-Path -Path "$PSScriptRoot\parameters\masterdeploysubrg.parameters.json") -baseParametersURL "https://$deploymentStorageAccountName.blob.core.windows.net/deployments/" -parametersSasToken $token -Verbose;

# Get public IP of core firewall that was just deployed
$corePUBLICip = (Get-AzureRmResourceGroupDeployment -ResourceGroupName Demo-Infra-FWCore-RG -Name "Fortigate2NIC-deploy-DemoFWCore01").Outputs.publicIP.value

$fwURL = "https://$corePUBLICip" + ":8443"
$dockerURL = "http://$corePUBLICip" + ":8080"
$RDPAddress = $corePUBLICip + ":33891"

# Apply policy
Write-Host "Applying Azure Policy on subscription..."
$workspaceName = (Get-AzureRmResourceGroupDeployment -ResourceGroupName Demo-Infra-LoggingSec-RG -Name "Workspace-Deploy-Demo-Workspace-unique-LA").Outputs.workspaceName.value

. (Resolve-Path "$PSScriptRoot\scripts\deployPolicy.ps1") -workspaceName $workspaceName

Write-Host "There was no deployment errors detected. All look good."
Write-Host "Connect to the Core firewall using a web browser and connect to $fwURL"