# Resourcegroups deployments
# Make sure to have Owner priviledge level in Azure to deploy the Resource Groups as locking requires Owner's level access. To increase level go to:
# https://portal.azure.com/#blade/Microsoft_Azure_PIM/CrossProviderActivationMenuBlade/azureResourceRoles/isAADGroupVisible//isAADRbacVisible/

Param(
    [string]$storageRG = "Demo-Infra-Storage-RG",
    [string]$storageAccountName = "deployments",
    [string]$containerName = "demo-core-cisco-v2",
    [string]$location = "canadacentral",
    [string]$configFilePath = "$PSScriptRoot\settings.xml"
)

function Cleanup {
    Write-Host "There was a deployment error detected. Exiting."
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
}
else {
    Write-Host "Since you opted not to license the ASAv I will not deploy the demo web server due to lack of throughput on the ASAv that would result if a deployment failure..."
}
((Get-Content -path $PSScriptRoot\ciscoasav\register.ios.template -raw) -replace '\[idtoken\]', $idtoken) | Set-Content -Path $tempDirName\register.ios

# sign in
#Write-Host "Logging in...";
if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    Write-Host "You need to login. Minimize the Visual Studio Code and login to the window that poped-up"
    Login-AzureRmAccount
}

Write-Host "Copying parameters files for deployment to https://$deploymentStorageAccountName.blob.core.windows.net/$containerName"

& (Resolve-Path -Path "$PSScriptRoot\scripts\upload-parameters-files.ps1") -containerName $containerName

Write-Host "Starting base infrastructure deployment..."

# Get storageaccount name that contains parameters files
$deploymentStorageAccountName = (Get-AzureRmResourceGroupDeployment -ResourceGroupName $storageRG -Name "storageAccount.$storageAccountName").Outputs.storageAccountName.value

$null = Set-AzureRmCurrentStorageAccount -ResourceGroupName $storageRG -Name $deploymentStorageAccountName

# Create the SaS token for the contrainer
$token = New-AzureStorageContainerSASToken -Name $containerName -Permission r -ExpiryTime (Get-Date).AddMinutes(90.0)

# Deploy base infrastructure
New-AzureRmDeployment -Location $Location -Name Base-Infrastructure -TemplateUri "https://azpwsdeployment.blob.core.windows.net/library/arm/masterdeploy/20190319.1/masterdeploysubrg.json" -TemplateParameterFile (Resolve-Path -Path "$PSScriptRoot\parameters\masterdeploysubrg.parameters.json") -baseParametersURL "https://$deploymentStorageAccountName.blob.core.windows.net/$containerName/" -parametersSasToken $token -Verbose;

$provisionningState = (Get-AzureRmDeployment -Name Base-Infrastructure).ProvisioningState

if ($provisionningState -eq "Failed") {
    Cleanup
}

# Get public IP of core firewall that was just deployed
$coreASAPIBLICip = (Get-AzureRmResourceGroupDeployment -ResourceGroupName Demo-Infra-FWCore-RG -Name "CiscoASAV2NIC-deploy-demo-asav-core").Outputs.publicIP.value

Write-Host "Configuring core firewall..."

#Configure cisco ASAv firewall. UGLY but work for now
cmd /c echo "y" | .\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m .\ciscoasav\core-base-config.ios $coreASAPIBLICip
.\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m .\ciscoasav\core-base-config.ios $coreASAPIBLICip
Start-Sleep -Seconds 5
.\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m $tempDirName\register.ios $coreASAPIBLICip

Write-Host "Waiting 60 seconds for core firewall to get license"
Start-Sleep -Seconds 60

cmd /c echo "y" | .\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m .\ciscoasav\mgmt-base-config.ios -P 10022 $coreASAPIBLICip
.\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m .\ciscoasav\mgmt-base-config.ios -P 10022 $coreASAPIBLICip
Start-Sleep -Seconds 5
.\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m $tempDirName\register.ios -P 10022 $coreASAPIBLICip

cmd /c echo "y" | .\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m .\ciscoasav\shared-base-config.ios -P 10023 $coreASAPIBLICip
.\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m .\ciscoasav\shared-base-config.ios -P 10023 $coreASAPIBLICip
Start-Sleep -Seconds 5
.\scripts\plink.exe -ssh -l azureadmin -pw Canada123! -m $tempDirName\register.ios -P 10023 $coreASAPIBLICip


Write-Host "Deploying Servser..."

# Deploy Server in infrastructure
if ($confirmation -eq 'y') {
    # Create the SaS token for the contrainer
    $token = New-AzureStorageContainerSASToken -Name $containerName -Permission r -ExpiryTime (Get-Date).AddMinutes(90.0)

    New-AzureRmDeployment -Location $Location -Name DockerDemo -TemplateUri "https://azpwsdeployment.blob.core.windows.net/library/arm/masterdeploy/20190319.1/masterdeployrg.json" -TemplateParameterFile (Resolve-Path -Path "$PSScriptRoot\parameters\masterdeployrg-dockerdemo.parameters.json") -baseParametersURL "https://$deploymentStorageAccountName.blob.core.windows.net/$containerName/" -parametersSasToken $token -Verbose;
    $provisionningState = (Get-AzureRmDeployment -Name DockerDemo).ProvisioningState

    if ($provisionningState -eq "Failed") {
        Cleanup
    }
} else {
    $token = New-AzureStorageContainerSASToken -Name $containerName -Permission r -ExpiryTime (Get-Date).AddMinutes(90.0)

    New-AzureRmDeployment -Location $Location -Name Jumpbox-DockerDemo -TemplateUri "https://azpwsdeployment.blob.core.windows.net/library/arm/masterdeploy/20190319.1/masterdeployrg.json" -TemplateParameterFile (Resolve-Path -Path "$PSScriptRoot\parameters\masterdeployrg-jump-docker.parameters.json") -baseParametersURL "https://$deploymentStorageAccountName.blob.core.windows.net/$containerName/" -parametersSasToken $token -Verbose;
    $provisionningState = (Get-AzureRmDeployment -Name Jumpbox-DockerDemo).ProvisioningState

    if ($provisionningState -eq "Failed") {
        Cleanup
    }
}

$dockerURL = "http://$coreASAPIBLICip"
$RDPAddress = $coreASAPIBLICip + ":3389"
$MGMTFirewallASDM = $coreASAPIBLICip + ":10443"
$SharedFirewallASDM = $coreASAPIBLICip + ":10444"

Write-Host "There was no deployment errors detected. All look good."
Write-Host
Write-Host "Connect to the Core firewall using ASDM to $coreASAPIBLICip"
Write-Host "Connect to the Management firewall using ASDM to $MGMTFirewallASDM"
Write-Host "Connect to the Shared firewall using ASDM to $SharedFirewallASDM"
Write-Host "Connect to the temporary Jumpbox server using RDP to $RDPAddress"

if ($confirmation -eq 'y') {
    # Web Server Deployments
    Write-Host "Connect to the demo website using a web browser at $dockerURL"
}