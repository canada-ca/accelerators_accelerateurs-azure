# Resourcegroups deployments
# Make sure to have Owner priviledge level in Azure to deploy the Resource Groups as locking requires Owner's level access. To increase level go to:
# https://portal.azure.com/#blade/Microsoft_Azure_PIM/CrossProviderActivationMenuBlade/azureResourceRoles/isAADGroupVisible//isAADRbacVisible/

Param(
    [string]$storageRG = "Demo-Infra-Storage-RG",
    [string]$subscriptionId = "",
    [string]$storageAccountName = "deployments",
    [string]$containerName = "demo-core-azfw-nsg",
    [string]$location = "canadacentral"
)

function Cleanup {
    Write-Host "There was a deployment error detected. Exiting."
    exit
}

$ErrorActionPreference = "Stop"

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

# Set policy

#$gcPolicySet = New-AzPolicySetDefinition -Name 'GC PBMM Policy Set' -PolicyDefinition (Resolve-Path "$PSScriptRoot\..\policy\gcpolicy.json")

#$isoPolicySet = Get-AzPolicySetDefinition -Id '/providers/Microsoft.Authorization/policySetDefinitions/89c6cddc-1c73-4ac1-b19c-54d1a15a42f2'


#New-AzPolicyAssignment -Name 'GC Audit ISO 27001:2013' -PolicySetDefinition $isoPolicySet -Scope "/subscriptions/$subscriptionId" -AssignIdentity -Location $location -Verbose
Remove-AzPolicyAssignment -Name 'GC Audit ISO 27001:2013' -Scope "/subscriptions/$subscriptionId"
Remove-AzPolicyAssignment -Name 'GC PBMM Policy Audit' -Scope "/subscriptions/$subscriptionId"
Remove-AzPolicySetDefinition -Name 'GC PBMM Policy Set' -Force