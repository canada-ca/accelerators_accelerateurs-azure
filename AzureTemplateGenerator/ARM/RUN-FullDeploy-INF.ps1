Write-Output "Provisioning Full Infrastructure Deployment"
Write-Output "Connecting to Azure Account..."
Connect-AzAccount
<# #>
Write-Output "Provisioning Policies"
#$sPOL = 
Get-ChildItem "$($PSScriptRoot)\00-POL\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Provisioning Log Analytics Workspace Resource Groups"
#$sLAWRG = 
Get-ChildItem "$($PSScriptRoot)\01-LAW\" | where-object {$_.name -like "*-RGP.ps1"} | % { & $_.FullName }
Write-Output "Provisioning Log Analytics Workspaces"
#$sLAW = 
Get-ChildItem "$($PSScriptRoot)\01-LAW\" | where-object {$_.name -like "*-LAW.ps1"} | % { & $_.FullName }
Write-Output "Provisioning Resource Groups"
#$sRG = 
Get-ChildItem "$($PSScriptRoot)\02-RG\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName } 
Write-Output "Provisioning Network Security Groups"
#$sNSG = 
Get-ChildItem "$($PSScriptRoot)\03-NSG\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Provisioning Route Tables"
#$sRT = 
Get-ChildItem "$($PSScriptRoot)\04-RT\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Provisioning Virtual Networks"
#$sVNET = 
Get-ChildItem "$($PSScriptRoot)\05-VNET\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Provisioning VNET Peerings"
#$sPEER = 
Get-ChildItem "$($PSScriptRoot)\06-PEER\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Provisioning Application Gateways"
#$sAG = 
Get-ChildItem "$($PSScriptRoot)\07-AG\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Provisioning Firewalls"
#$sFW = 
Get-ChildItem "$($PSScriptRoot)\08-FW\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Provisioning Storage Accounts"
#$sSA = 
Get-ChildItem "$($PSScriptRoot)\09-SA\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Provisioning Recovery Service Vaults"
#$sRSV = 
Get-ChildItem "$($PSScriptRoot)\10-RSV\" | where-object {$_.extension -eq ".ps1"} | % { & $_.FullName }
Write-Output "Finished!"