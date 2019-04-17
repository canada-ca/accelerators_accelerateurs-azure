# Resourcegroups deployments
# Make sure to have Owner priviledge level in Azure to deploy the Resource Groups as locking requires Owner's level access. To increase level go to:
# https://portal.azure.com/#blade/Microsoft_Azure_PIM/CrossProviderActivationMenuBlade/azureResourceRoles/isAADGroupVisible//isAADRbacVisible/

Param(
    [string]$storageRG = "Demo-Infra-Storage-RG",
    [string]$subscriptionId = "",
    [string]$storageAccountName = "deployments",
    [string]$containerName = "demo-core-azfw-nsg",
    [string]$workspaceName = "",
    [string]$location = "canadacentral"
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

$tempDirName = New-TemporaryDirectory
$tempDirName = $tempDirName.ToString()

# sign in
#Write-Host "Logging in...";
if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    Write-Host "You need to login. Minimize the Visual Studio Code and login to the window that poped-up"
    Login-AzureRmAccount
}

if (![string]::IsNullOrEmpty($subscriptionId)) {
    Select-AzureRmSubscription -Subscription $subscriptionId
} else {
    $subscriptionId = (Get-AzureRmContext).Subscription.Id
}

# Replace default value with provided workspaceName
((Get-Content -path (Resolve-Path "$PSScriptRoot\..\policy\gcpolicy.json") -raw) -replace 'Demo-Workspace-\[unique\]-LA', $workspaceName) | Set-Content -Path $tempDirName\gcpolicy.json

# Get-Content -Path $tempDirName\gcpolicy.json

# Set policy

$gcPolicySet = New-AzureRMPolicySetDefinition -Name 'GC PBMM Policy Set' -PolicyDefinition "$tempDirName\gcpolicy.json"

$isoPolicySet = Get-AzureRMPolicySetDefinition -Id '/providers/Microsoft.Authorization/policySetDefinitions/89c6cddc-1c73-4ac1-b19c-54d1a15a42f2'
 
New-AzureRMPolicyAssignment -Name 'GC Audit ISO 27001:2013' -PolicySetDefinition $isoPolicySet -Scope "/subscriptions/$subscriptionId" -AssignIdentity -Location $location -Verbose

New-AzureRMPolicyAssignment -Name 'GC PBMM Policy Audit' -PolicySetDefinition $gcPolicySet -Scope "/subscriptions/$subscriptionId" -AssignIdentity -Location $location -Verbose