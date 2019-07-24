Param(
    [string]$containerName = "devops",
    [string]$storageRG = "AzPwS01-Infra-Storage-RG",
    [string]$storageAccountName = "azpwsdeployment",
    [string]$subscriptionId = "",
    [string]$archiveName = "deployments-subscription-archive",
    [switch]$doNotDelete = $false,
    [switch]$doNotArchive = $false
)

$templateBlobDestUrl = "https://$storageAccountName.blob.core.windows.net/$containerName/$archiveName"

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

# Select-AzureRmSubscription -SubscriptionID $subscriptionId

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

if (![string]::IsNullOrEmpty($subscriptionId)) {
    Select-AzureRmSubscription -Subscription $subscriptionId
}

$tempDirName = New-TemporaryDirectory
$tempDirName = $tempDirName.ToString()

$deployments = Get-AzureRmDeployment

if(!$deployments){
    Write-Host "There are no deployments to archive. Exiting."
    exit
}

Write-Host "List of deployments to action:"
foreach ($deployment in $deployments) {
    Write-Host $deployment.DeploymentName
}

$actionList = ""
if(!$doNotArchive) { $actionList += " archive" }
if(!$doNotDelete) { $actionList += " delete" }

Write-Host "The following deployments actions $actionList will be performed on the above listed deployments..."
$confirmation = Read-Host "Are you Sure You Want To Perform The Actions (y/n)"
if ($confirmation -eq 'y') {
    if (!$doNotArchive) {
        $destKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storageRG -AccountName $storageAccountName).Value[0]
        
        Write-Host "Archiving deployments..."
        # Run this 1st to save all deployment content to temp folder before deleting them from the subscription
        foreach ($deployment in $deployments) {
            $cmdOutput = Get-AzureRmDeployment -Name $deployment.DeploymentName

            $fileName = $tempDirName + "\" + $deployment.DeploymentName + ".txt"

            $cmdOutput | Out-File -filepath $fileName
        }

        # Upload deployment archive files to Azure
        azcopy /Source:$tempDirName /Dest:$templateBlobDestUrl /DestKey:$destKey /S /Y

        # Cleanup temp directory
        Remove-Item -Recurse -Force $tempDirName
    }

    if (!$doNotDelete) {
        Write-Host "Deleting deployments from Azure..."
        foreach ($deployment in $deployments) {
            Remove-AzureRmDeployment -Name $deployment.DeploymentName -AsJob -Verbose
        }
    }
}