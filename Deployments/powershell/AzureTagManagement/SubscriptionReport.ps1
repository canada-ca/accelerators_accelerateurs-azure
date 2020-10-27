#requires -version 5
<#
.SYNOPSIS
    Generate a report on resource groups and tags.
.DESCRIPTION
    Commented code included to retrieve cost data for each resource group.
.PARAMETER null2
    
.PARAMETER null
    
.INPUTS
    None.
.OUTPUTS
    None.
.NOTES
    Version:        1.0
    Author:         Ken Morency - Transport Canada
    Creation Date:  Monday October 26, 2020
    Purpose/Change: Initial script development

    MIT License

    Copyright (c) 2019 Government of Canada - Gouvernement du Canada

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

    TODOs:
    1. 
.EXAMPLE
    .PS> .\TagManagement.ps1
.LINK
    
#>

$WarningPreference = 'SilentlyContinue'

function AzConnected {
    Get-AzSubscription -ErrorAction SilentlyContinue | out-null
    $result = $?
    return $result
}

if (-not (AzConnected)) {
    Connect-AzAccount
}

#Uncomment for previous months cost (Warning: SLOW)
#$BillingPeriodName = (Get-Date).AddMonths(-1) | Get-date -f "yyyyMM"
$csvPath = "$($PSScriptRoot)\SubscriptionReport-$(get-date -f yyyy-MM-dd-hh-mm).csv"
$out = ""

$RGs = @()
$Subscriptions = Get-AzSubscription
foreach ($sub in $Subscriptions) {
    $out = Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
    #Swap for below for a single Sub testing. You'll need to comment out the Sub Call/Loop.
    #$sub = Get-AzSubscription -SubscriptionName "PROD" | Set-AzContext
    
    
    Write-Host ""
    Write-Host "Fetching Resource Group Data from: $($sub.Name)"
    $resourceGroups = Get-AzResourceGroup
    $rgIndexId = 0

    foreach ($rg in $resourceGroups) {
        #Uncomment for cost (Warning: SLOW)
        #$costs = Get-AzConsumptionUsageDetail -ResourceGroup $rg.ResourceGroupName -BillingPeriodName $BillingPeriodName | select InstanceName, PretaxCost | Measure-Object -Sum PretaxCost
        <#
        $costs = Get-AzConsumptionUsageDetail -ResourceGroup $rg.ResourceGroupName  -StartDate '4/1/2019' -EndDate '3/31/2020' | select InstanceName, PretaxCost | Measure-Object -Sum PretaxCost

        #Write-Host $costs
        if ($null -ne $costs.Sum) {
            $short = [math]::Round($costs.Sum,2)
            $shortstring = $short
        } else {
            $shortstring = "0.00"
        }
        Write-Host -NoNewline $shortstring"/"
        $resourceGroups[$rgIndexId] | Add-Member -MemberType NoteProperty -Name "Cost" -Value $shortstring
        #>
        $resourceGroups[$rgIndexId] | Add-Member -MemberType NoteProperty -Name "Subscription" -Value $sub.Name
        Write-Host "-" -NoNewline
        $rgIndexId ++
    }
    Write-Host -NoNewline $rgIndexId
    $RGs += $resourceGroups
}

#Uncomment for trimmed report + cost (Warning: SLOW)
#$out = $RGs | Select-Object @{n='Subscription';e={$_.Subscription}},@{n='Resource Group';e={$_.ResourceGroupName}},@{n='Cost';e={$_.Tags['Cost']}},@{n='Solution-name';e={$_.Tags['Solution-name']}},@{n='Location';e={$_.Location}}  | Sort-Object Subscription,Solution-name,Location,ResourceGroup | Export-Csv -Path $csvPath -Encoding ascii -NoTypeInformation

#This section needs to be edited if you want to report on specific tags without costs.
$out = $RGs | Select-Object @{n='Subscription';e={$_.Subscription}},@{n='Resource Group';e={$_.ResourceGroupName}},@{n='AutoShutDown';e={$_.Tags['AutoShutDown']}},@{n='BuiltBy';e={$_.Tags['BuiltBy']}},@{n='BuiltOn';e={$_.Tags['BuiltOn']}},@{n='Business-unit';e={$_.Tags['Business-unit']}},@{n='TfFolder';e={$_.Tags['TfFolder']}},@{n='Location';e={$_.Location}}  | Sort-Object Subscription,Solution-name,Location,ResourceGroup | Export-Csv -Path $csvPath -Encoding ascii -NoTypeInformation

Write-Host ""
Write-Host "Completed Report!"