#requires -version 5
<#
.SYNOPSIS
    Fetches all unique tag names (case sensitive) from your subscriptions. 
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
    .PS> .\UniqueTags.ps1
.LINK
    
#>

function AzConnected {
    Get-AzSubscription -ErrorAction SilentlyContinue | out-null
    $result = $?
    return $result
}

if (-not (AzConnected)) {
    Connect-AzAccount
}

$UniqueTags = $null
$Subscriptions = Get-AzSubscription
foreach ($sub in $Subscriptions) {
    $out = Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
    $ResourceGroups = Get-AzResourceGroup
    $UniqueTags += $ResourceGroups.Tags.GetEnumerator().Keys | Select-Object -Unique
}
$UniqueTags | Select-Object -Unique