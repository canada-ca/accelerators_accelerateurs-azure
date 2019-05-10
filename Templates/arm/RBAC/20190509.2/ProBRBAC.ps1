<# 
#Description:
    PowerShell script using Az module to automate the role assignment for users & groups on subscriptions & management groups

#Author:
    Mohamed Sharaf - Mohamed.Sharaf@Microsoft.com

#Disclaimer:
 The sample scripts are not supported under any Microsoft standard support program or service. The sample scripts are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages.   

#Usage
use the proBRBAC.paramaters.json file to fill all the required roles and execute this file
#>

$parametersFilePath="ProBRBAC.paramaters.json"

$scriptDir=split-path -path ($MyInvocation.MyCommand.path)
Push-Location $scriptDir

if(Test-Path -Path $parametersFilePath)
{
    $rolesToApply=Get-Content $parametersFilePath -Raw | ConvertFrom-Json -AsHashtable
}
else {
    throw "parameters file not found"
}

foreach($role in $rolesToApply)
{
    .\AssignRoletoPrincipal.ps1 -location $role.location -subscriptionId $role.subscriptionID `
    -roleName $role.roleName -scopeLevel $role.scopeLevel `
    -managementGroupID $role.managementGroupID -userPrincipalName $role.userPrincipalName `
    -groupDisplayName $role.groupDisplayName 
}



Pop-Location