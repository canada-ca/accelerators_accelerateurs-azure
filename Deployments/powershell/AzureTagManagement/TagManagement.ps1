#requires -version 5
<#
.SYNOPSIS
    Add, Delete or Remap Azure Resource Group Tags.
.DESCRIPTION
    
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
$global:sSrcTag = ""
$global:sDestTag = ""
$global:sDelTag = ""
$global:sAddTag = ""
$global:sTagVal = ""

#region FUNCTIONS
function AzConnected {
    Get-AzSubscription -ErrorAction SilentlyContinue | out-null
    $result = $?
    return $result
}
function Show-Menu
{
     param (
           [string]$Title = 'TC Tag Management Tool'
     )
     Clear-Host
     Write-Host "================ $Title ================"
    
     Write-Host "R: Press 'R' to remap a tag."
     Write-Host "D: Press 'D' to delete a tag."
     Write-Host "A: Press 'A' to add a new tag."
     Write-Host "Q: Press 'Q' to quit."
}

function RemapTag
{
    Write-Host ""
    Write-Host "Remap Tag Values. This will NOT delete 'Source' tags/values. *Case Sensitive*"
    $global:sSrcTag = Read-Host "Source Tag Name"
    $global:sDestTag = Read-Host "Destination Tag Name"

}

function DeleteTag
{
    Write-Host ""
    Write-Host "Delete Tags. This will delete ALL 'Target' tags/values on all resource groups."
    $global:sDelTag = Read-Host "Target Tag Name to Delete"
}

function AddTag
{
    Write-Host ""
    Write-Host "Add New Tag. This will add 'New' tags with a default value to ALL resource groups."
    $global:sAddTag = Read-Host "New Tag Name to Add"
    $global:sTagVal = Read-Host "New Tag Value"
}

#endregion

if (-not (AzConnected)) {
    Connect-AzAccount
}

do
{

    $bLoop = $false

    Show-Menu
    $uChoice = Read-Host "Please make a selection"
    switch ($uChoice)
    {
        'r' {
            RemapTag
            $bLoop = $true
        } 'd' {
            DeleteTag
            $bLoop = $true
        } 'a' {
            AddTag
            $bLoop = $true
        } 'q' {
            $bLoop = $false
            return
        }
    }

    if ($bLoop -eq $true) {
        $out = ""
        $RGs = @()
        
        $Subscriptions = Get-AzSubscription
        foreach ($sub in $Subscriptions) {
            $out = Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
            Write-Host ""
            Write-Host "Managing Resource Group Tags in: $($sub.Name)"
            
            $resourceGroups = Get-AzResourceGroup
            $rgIndexId = 0

            foreach ($rg in $resourceGroups) {
                if ($null -ne $rg.Tags) {
                    foreach ($tag in $rg.Tags.GetEnumerator()) {
                        switch ($uChoice)
                        { 
                            'r' {
                                #Remap
                                #case sensitive compare!!
                                if ($tag.Key -ceq $global:sSrcTag) {
                                    $tmpVal = $tag.Value
                                    Write-Host "$($rg.ResourceGroupName):S-$($global:sSrcTag)/D-$($global:sDestTag)/V-$($tmpVal)"
                                    $mergedTags = @{$global:sDestTag=$tmpVal;}
                                    #Uncomment line below to execute merge of new tag into existing tags.
                                    #Update-AzTag -ResourceId $rg.ResourceId -Tag $mergedTags -Operation Merge
                                }
                                    
                            } 'd' {
                                #Delete
                                if ($tag.Key -ceq $global:sDelTag) {
                                    $tmpVal = $tag.Value
                                    Write-Host "$($rg.ResourceGroupName):T-$($global:sDelTag)/V-$($tmpVal)"
                                    $deletedTags = @{$global:sDelTag=$tmpVal;}
                                    #Uncomment line below to execute delete of specific tag in resource group.
                                    #Update-AzTag -ResourceId $rg.ResourceId -Tag $deletedTags -Operation Delete
                                }
                            } 'a' {
                                #Add
                                $tmpVal = $global:sTagVal
                                if ($tmpVal -ne "" -And $null -ne $tmpVal) {
                                    $addedTags = @{$sAddTag=$tmpVal;}
                                    Write-Host "$($rg.ResourceGroupName):T-$($global:sAddTag)/V-$($tmpVal)"
                                    #Uncomment line below to execute addition of new tag in resource group.
                                    #Update-AzTag -ResourceId $rg.ResourceId -Tag $addedTags -Operation Merge
                                }
                            }
                        }
                    }
                }
                $rgIndexId ++
            }
            Write-Host -NoNewline $rgIndexId "Resource Groups"
            $RGs += $resourceGroups
        }
    }
    Write-Host ""
    pause
}
until ($uChoice -eq 'q')
