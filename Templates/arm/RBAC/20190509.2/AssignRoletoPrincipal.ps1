<# 
#Description:
    PowerShell script using Az module to automate the role assignment for users & groups on subscriptions & management groups

#Author:
    Mohamed Sharaf - Mohamed.Sharaf@Microsoft.com

#Disclaimer:
 The sample scripts are not supported under any Microsoft standard support program or service. The sample scripts are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages.   

#Examples
user principal - subscription
.\AssignRoletoPrincipal.ps1 -location "CanadaCentral" -roleName "Contributor" -scope "subscription" -userPrincipalName "aqasrawi@microsoft.com"
group - subscription
.\AssignRoletoPrincipal.ps1 -location "CanadaCentral" -roleName "Contributor" -scope "subscription" -groupDisplayName "snow-uat-users"

user principal - management groups
.\AssignRoletoPrincipal.ps1 -location "CanadaCentral" -roleName "Contributor" -scope "managementGroup" -userPrincipalName "aqasrawi@microsoft.com" -managementGroupID "mosharaf"
#>
param(
    [string]
    $subscriptionId,
   
    [Parameter(Mandatory=$True)]
    [string]
    $location,

    [Parameter(Mandatory=$True)]
    [string]
    $roleName,

    [Parameter(Mandatory=$True)]
    [ValidateSet('subscription','managementGroup')]
    [string]
    $scopeLevel,

    [string]
    $managementGroupID,
    
    [string]
    $userPrincipalName,

    [string]
    $groupDisplayName,

    [string]
    $templateFilePath = "AzureDeploy.json",
   
    [string]
    $parametersFilePath = "AzureDeploy.parameters.json"
   )

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

#validation
If($userPrincipalName -ne "" -and $groupDisplayName -ne "")
{
    throw "Provide either user or group not both" 
}

if($scopeLevel -eq "managementGroup" -and $managementGroupID -eq "")
{
    throw "Provide managementGroupID if the scopeLevel is managementGroup"
}

#check if already logged in
$context=Get-AzContext

If($context -eq $null)
{
    # sign in
    Write-Host "Logging in...";
    Login-AzAccount;
}else{
    Write-Host "Already logged in"
}

# select subscription
if($subscriptionId -ne "")
{
    Write-Host "Selecting subscription '$subscriptionId'";
    Select-AzSubscription -SubscriptionID $subscriptionId;
}

# get the role id depends on the assignment scopeLevel
if($scopeLevel -eq "subscription")
{
    $role =  Get-AzRoleDefinition -Name $roleName  
    if($role -eq $null)
    {
        throw "Role not found in the specified scope"
    }
}
else {
    $role = Get-AzRoleDefinition -Name $roleName -Scope "/providers/Microsoft.Management/managementGroups/$managementGroupID"
    if($role -eq $null)
    {
        throw "Role not found in the specified scope"
    }
}

#get principal id
if($userPrincipalName -ne "")
{
    $principal=Get-AzADUser -UserPrincipalName $userPrincipalName
    if($principal -eq $null)
    {
        throw "user principal not found"
    }
}else
{
    $principal=Get-AzADGroup -DisplayName $groupDisplayName
    if($principal -eq $null)
    {
        throw "group not found"
    }
}

#####################################################################
#if scope level is managementGroup, use PowerShell not ARM template
If($scopeLevel -eq "managementGroup")
{
    New-AzRoleAssignment -ObjectId $principal.Id -RoleDefinitionId $role.Id -Scope "/providers/Microsoft.Management/managementGroups/$managementGroupID"
    return 
}
#####################################################################




#change the location to the script location
$scriptDir=split-path -path ($MyInvocation.MyCommand.path)
Push-Location $scriptDir

if(Test-Path -Path $parametersFilePath)
{
    $parametersObject=Get-Content $parametersFilePath -Raw | ConvertFrom-Json -AsHashtable
}
else {
    throw "parameters file not found"
}

$parametersObject.roleDefinitionID=$role.Id
$parametersObject.principalID=$principal.Id
$parametersObject.scopeLevel=$scopeLevel
$parametersObject.managementGroupID=$managementGroupID

$deploymentName= "Deployment-$(New-Guid)" 

New-AzDeployment -Name $deploymentName -Location $location `
-TemplateFile $templateFilePath -TemplateParameterObject $parametersObject -DeploymentDebugLogLevel All 

Pop-Location

Write-Host "Deployment Complete"