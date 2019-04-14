Param(
    [Parameter(Mandatory = $True)][string]$templateLibraryName = "deployment template file formatted as templateMame/version",
    [Parameter(Mandatory = $True)][string]$parametersFileName = "path to deployment parameter file",
    [string]$templateName = "azuredeploy.json",
    [string]$containerName = "library",
    [string]$storageRG = "",
    [string]$storageAccountName = "azpwsdeployment",
    [string]$Location = "canadacentral",
    [string]$subscriptionId = "",
    [string]$configFilePath = "",
    [string]$deploymentName = "",
    [switch]$AsJob = $false,
    [switch]$timestamp = $false
)

function Output-DeploymentName {
    param( [string]$Name)

    $pattern = '[^a-zA-Z0-9-]'

    # Remove illegal characters from deployment name
    $Name = $Name -replace $pattern, ''

    # Truncate deplayment name to 64 characters
    $Name.subString(0, [System.Math]::Min(64, $Name.Length))
}

if($configFilePath) {
    #Write-Host "Assigning script variables from $configFilePath..."
    [xml]$ConfigFile = Get-Content $configFilePath
    $Location = $ConfigFile.Settings.resourceGroupLocation
}

$date = ("{0:yyyyMMdd}" -f (get-date)).ToString()
$time = ("{0:HHmmss}" -f (get-date)).ToString()
$templateLibraryNameSplit = $templateLibraryName.split("/")[0]
$timestampStr = "$date-$time"

if (!$deploymentName) {
    $deploymentName = Output-DeploymentName("$timestampStr-$templateLibraryNameSplit-$parametersFileName")
}

$templateARMBlobUrl = "https://$storageAccountName.blob.core.windows.net/$containerName/arm/$templateLibraryName/$templateName"
$url = $templateARMBlobUrl

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

#Select-AzureRmSubscription -SubscriptionID $subscriptionId

# Start the deployment
Write-Host "Starting deployment...";
$parametersFileNameResolve = Resolve-Path $parametersFileName
if ($AsJob) {
    
    New-AzureRmDeployment -Location $Location -Name $deploymentName -TemplateUri $url -TemplateParameterFile $parametersFileNameResolve -Verbose -AsJob
} 
else {
    New-AzureRmDeployment -Location $Location -Name $deploymentName -TemplateUri $url -TemplateParameterFile $parametersFileNameResolve -Verbose
}