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

# vmdiag storage for servers
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName storage/20190302.2 -parametersFileName .\deploy-55-storage.parameters.json -resourceGroupName Demo-Shared-Sandbox-RG

# Web Server Deployments
.\scripts\deployrgv2.ps1 -configFilePath $configFilePath -templateLibraryName servers/20190307.1 -parametersFileName .\deploy-61-servers.parameters.json -resourceGroupName Demo-Shared-Sandbox-RG