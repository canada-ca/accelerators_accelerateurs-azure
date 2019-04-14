# Resourcegroups deployments
# Make sure to have Owner priviledge level in Azure to deploy the Resource Groups as locking requires Owner's level access. To increase level go to:
# https://portal.azure.com/#blade/Microsoft_Azure_PIM/CrossProviderActivationMenuBlade/azureResourceRoles/isAADGroupVisible//isAADRbacVisible/

$scriptPath = $PSScriptRoot

# sign in
#Write-Host "Logging in...";
if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    Write-Host "You need to login. Minimize the Visual Studio Code and login to the window that poped-up"
    Login-AzureRmAccount
}

$coreASAPIBLICip = (Get-AzureRmResourceGroupDeployment -ResourceGroupName Demo-Infra-FWCore-RG -Name "CiscoASAV2NIC-deploy-demo-asav-core" -ErrorVariable notPresent -ErrorAction SilentlyContinue).Outputs.publicIP.value

if (!$notPresent) {
    #Configure cisco ASAv firewall. UGLY but work for now
    Write-Host "Unregistering Cisco ASAv licenses..."
    & "$scriptPath\plink.exe" -ssh -l azureadmin -pw Canada123! -m $scriptPath\..\ciscoasav\unregister.ios -P 10022 $coreASAPIBLICip
    & "$scriptPath\plink.exe" -ssh -l azureadmin -pw Canada123! -m $scriptPath\..\ciscoasav\unregister.ios -P 10023 $coreASAPIBLICip
    & "$scriptPath\plink.exe" -ssh -l azureadmin -pw Canada123! -m $scriptPath\..\ciscoasav\unregister.ios $coreASAPIBLICip

    Write-Host "Please verify that the licenses have been returned at:"
    Write-Host "    https://software.cisco.com/software/csws/ws/platform/home?locale=en_US#SmartLicensing-Inventory"
    Write-Host "before deleting the infrastructure..."
    Write-Host ""
}