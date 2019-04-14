#
# Extremelly dangerous script. It will delete everything in a subscription
#

Get-AzureRmContext
$currentSubscription = (Get-AzureRmContext).Subscription
$groups = Get-AzureRmResourceGroup -Name "Demo-*"

if ($groups) {
    $confirmation = Read-Host "Are you Sure You Want To Delete All Resources in Subscription $currentSubscription (y/n)"
    if ($confirmation -eq 'y') {
        Write-Host "List of resourcegroups to delete:"
        foreach ($group in $groups) {
            $cmdOutput = $group.ResourceGroupName
            Write-Host "$cmdOutput"
        }

        $confirmation2 = Read-Host "Are you REALLY REALLY REALLY Sure You Want To Proceed and Delete the Resource Groups Listed Above (y/n)"
        if ($confirmation2 -eq 'y') {
            Get-AzureRmResourceLock | Remove-AzureRmResourceLock -Verbose -Force
            Get-AzureRmResourceGroup -Name "Demo-*" | Remove-AzureRmResourceGroup -Verbose -Force -AsJob

            Get-Job | Wait-Job

            Start-Sleep -Seconds 2

            # Deleting RG that could not be deleted due to dependancies
            Get-AzureRmResourceLock | Remove-AzureRmResourceLock -Verbose -Force
            Get-AzureRmResourceGroup -Name "Demo-*" | Remove-AzureRmResourceGroup -Verbose -Force -AsJob
        }
    }
} else {
    Write-Host "No resourcegroups to delete. Exiting!"
}