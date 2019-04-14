$resourceGroupName = "backup-sbx-rg"
$Location = "canadacentral"
$templateFolder = $PSScriptRoot
$containerName ="devops"
$storageRG = "rgStorageAcct"
$storageAccountName = "cccsandboxdeployments"
$templateBlobDest = "https://$storageAccountName.blob.core.windows.net/$containerName/backups/"
$destKey = "OAVhx2VCIuOzRCK5h/2H1f4IEIdthDidbnAas1pwIq/7GqDTFw3FvZ96/pFFbmhsvDaa3uJ2xuHTyIcz6Hv4hQ=="
$backupVaultTemplateFileName = "backups/backup-vault.json"
$backupVaultParametersFileName = "backup-vault.parameters.json"
$backupPolicyTemplateFileName = "backups/backup-policy.json"
$backupPolicyParametersFileName = "backup-policy.parameters.json"

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# sign in
#Write-Host "Logging in...";
#Login-AzureRmAccount;

# Upload any updates to Azure
azcopy /Source:$templateFolder /Dest:$templateBlobDest /DestKey:$destKey /S /Y

Set-AzureRmCurrentStorageAccount -ResourceGroupName $storageRG -Name $storageAccountName

#Create the SaS token for the contrainer
$token = New-AzureStorageContainerSASToken -Name $containerName -Permission r -ExpiryTime (Get-Date).AddMinutes(5.0)
#Get the file urls from the blob storage.  
$urlVault = (Get-AzureStorageBlob -Container $containerName -Blob $backupVaultTemplateFileName).ICloudBlob.uri.AbsoluteUri + $token
$urlPolicy = (Get-AzureStorageBlob -Container $containerName -Blob $backupPolicyTemplateFileName).ICloudBlob.uri.AbsoluteUri + $token

# Start the deployment
Write-Host "Starting deployment...";
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName  -TemplateUri $urlVault -TemplateParameterFile $backupVaultParametersFileName -Verbose;
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $urlPolicy -TemplateParameterFile $backupPolicyParametersFileName -Verbose;