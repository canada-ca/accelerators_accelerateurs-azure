#requires -version 5
<#
.SYNOPSIS
    Add Application Gateways Settings
.DESCRIPTION
    Allows you to add new application gateway settings in Azure.
.PARAMETER null2
    
.PARAMETER null
    
.INPUTS
    None.
.OUTPUTS
    None.
.NOTES
    Version:        1.0
    Author:         Ken Morency - Transport Canada
    Creation Date:  Tuesday March 17, 2020
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
    .PS> .\AddAGWDomainSettings.ps1
.LINK
    
#>

$sScriptVersion = "1.0"
$sScriptName = "Add Application Gateways Settings"
$title_color = @{ForegroundColor = "cyan"}
$option_color = @{ForegroundColor="blue"; BackgroundColor="white"}
$success_color = @{ForegroundColor = "green"}
$select_color = @{ForegroundColor = "cyan"}
$error_color = @{ForegroundColor = "red"}
$AppGW = $null
$mnuDefaults = @("[Q] Quit")
$modes = @("[P]aaS","[I]aaS")
$mode = "PaaS"

#Set variables to suit environment needs.
$sAGWLive = "CORE-CACN-MAIN-AGW"
$sAGWLiveLocation = "Canada Central"
$sAGWDR = "CORE-CAEA-MAIN-AGW"
$sAGWDRLocation = "Canada East"
$sAppGWFEIP = "appGatewayFrontendIP"
$certs = @("TC-GC-CAvaultCert","TC-CANADA-CAvaultCert")
$sPort80Name = "appGatewayFrontendPort"
$sPort443Name = "port_443"

#region FUNCTIONS
function AzConnected {
    Get-AzSubscription -ErrorAction SilentlyContinue | out-null
    $result = $?
    return $result
}

function Show-MainMenu
{
    #Write-Host "Choose Region:" @option_color
    Write-Host "N: Press 'C' Canada Central"
    Write-Host "P: Press 'E' Canada East"
    Write-Host "Q: Press 'Q' to quit."
    Write-Host ""
}

function Show-ModeMenu
{
    #Write-Host "Choose Region:" @option_color
    Write-Host "I: Press 'I' IaaS (VM)"
    Write-Host "P: Press 'P' PaaS (Web App/Service)"
    Write-Host "Q: Press 'Q' to quit."
    Write-Host ""
}

function BuildMenuEven {
    param ($aList)
    # Create blank array to hold menu
    $formattedList = @()

    # Half and Half Columns
    for($i=0;$i -lt $aList.Count/2; $i++) {
        if ($null -ne $aList[$([Math]::Ceiling($aList.Count/2)+$i)]) {
            $formattedList += [PSCustomObject]@{
                Column1 = "$($aList[$i]) ";
                Column2 = "$($aList[$([Math]::Ceiling($aList.Count/2)+$i)]) "
            }
        }
        else {
            $formattedList += [PSCustomObject]@{
                Column1 = "$($aList[$i]) ";
                Column2 = ""
            } 
        }
    }
    # Output menu
    $formattedList | Format-Table -HideTableHeaders
}

#endregion FUNCTIONS


if (-not (AzConnected)) {
    Connect-AzAccount
}

Clear-Host
$ErrorActionPreference = "Stop"
Write-Host "$($sScriptName) v$($sScriptVersion)" @option_color

$iQuit=$false
While ($iQuit -eq $false) {
    #Write-Host $modeSubs $iSubs 
    $isBadChoice = $false
    $modeRegion = $false
    $isGoodMode = $false
    $EPMode = $false
    $mode = ""
    $modeCert = ""

    Write-Host ""
    Write-Host "REGION - Make a selection:" @select_color
    Show-MainMenu
    $modeRegion = Read-Host
    switch -regex ([string]$modeRegion) #CHOOSE REGION
    {
        "^[C]$" {
            Write-Host ""
            Write-Host "$($sAGWLiveLocation) - $($sAGWLive)" @success_color
            $AppGW = Get-AzApplicationGateway -Name $sAGWLive
        }
        "^[E]$" {
            Write-Host ""
            Write-Host "$($sAGWDRLocation) - $($sAGWDR)" @success_color
            $AppGW = Get-AzApplicationGateway -Name $sAGWDR
        }
        "^[Q]$" {
            #QUIT
            Write-Host "GOODBYE!" @option_color
            Write-Host ""
            $iQuit = $true
            $isBadChoice=$true
        }
        default {
            Write-Host "Invalid Selection, Please Try Again." @error_color
            $isBadChoice=$true
        }
    }
    if ($isBadChoice -eq $false) {
        
        $isGoodMode = $false
        While ($isGoodMode -eq $false -And $iQuit -eq $false) {
            Write-Host ""
            Write-Host "Endpoint Mode, make a selection (Default: [P]aaS)" @select_color
            Show-ModeMenu
            $EPMode = Read-Host

            switch -regex ([string]$EPMode) #CHOOSE ENDPOINT MODE
            {
                "^[I]$" {
                    $mode = "IaaS"
                    $isGoodMode = $true
                }
                "^[P]$" {
                    $mode = "PaaS"
                    $isGoodMode = $true
                }
                "^[Q]$" {
                    $iQuit = $true
                    Write-Host "GOODBYE!" @success_color
                }
                default {
                    Write-Host "Invalid Choice!"
                }
            }
        }

        if ($iQuit -eq $false) {
            Write-Host "" @option_color
            #Uncomment below to allow custom Listener Name
            #$ListenerName = Read-Host "Listener Name (Ex. YOURDEPT-GC-CA, Default: TEST-GC-CA)"
            #if ($ListenerName -eq "" -or $null -eq $ListenerName) {
            #    $ListenerName = "TEST-GC-CA"
            #}
            
            $ListenerURL = Read-Host "Listener Domain (Ex. yourdept.gc.ca, Default: test.gc.ca)"
            if ($ListenerURL -eq "" -or $null -eq $ListenerURL) {
                $ListenerURL = "test.gc.ca"
            }
            
            #Comment out the line below if allowing custom Listener Name.
            $ListenerName = $ListenerURL

            $BackendTarget = Read-Host "Backend Target (Ex. yourdept.azurewebsites.net OR 192.168.0.1, Default: test.azurewebsites.net)"
            if ($BackendTarget -eq "" -or $null -eq $BackendTarget) {
                $BackendTarget = "test.azurewebsites.net"
            }

            $iCerts = 0
            [System.Collections.ArrayList]$MyCerts = $mnuDefaults
            foreach ($curCert in $certs) {
                $sBlank = $MyCerts.Add("[" + $iCerts + "] " + $curCert)
                $iCerts ++
            }
        }

        $isGoodCert = $false
        While ($isGoodCert -eq $false -And $iQuit -eq $false) {
            Write-Host ""
            Write-Host "SSL Certificates, make a selection:" @select_color
            BuildMenuEven($MyCerts)
            $modeCert = Read-Host
    
            switch -regex ([string]$modeCert) #CHOOSE CERTIFICATE
            {
                "^[0-$($iCerts)]$" {
                    $isGoodCert = $true
                }
                "^[Q]$" {
                    $iQuit = $true
                    Write-Host "GOODBYE!" @option_color
                }
                default {
                    Write-Host "Invalid Choice!"
                }
            }

            if ($iQuit -eq $false -And $isGoodCert -eq $true -And $isGoodMode -eq $true) {
                #Write-Host $certs[$modeCert]
                Write-Host "Building App Gateway Rule Stack" @option_color
                Write-Host ""
                #Front End Port 80
                $AGFEPort80 = Get-AzApplicationGatewayFrontendPort -ApplicationGateway $AppGW -Name $sPort80Name
                Write-Host "Fetched: $($sPort80Name)" @success_color
                #Front End Port 443
                $AGFEPort443 = Get-AzApplicationGatewayFrontendPort -ApplicationGateway $AppGW -Name $sPort443Name
                Write-Host "Fetched: $($sPort443Name)" @success_color
                #Front End IP
                $AGFEIPConfig = Get-AzApplicationGatewayFrontendIPConfig -ApplicationGateway $AppGW -Name $sAppGWFEIP
                Write-Host "Fetched: $($sAppGWFEIP)" @success_color
                #SSL Cert
                $AGFECert = Get-AzApplicationGatewaySslCertificate -ApplicationGateway $AppGW -Name $certs[$modeCert]
                Write-Host "Fetched: $($certs[$modeCert])" @success_color

                #Add Port 80 Listener
                $80ListenerName = "80-$($ListenerName)"
                $result = Add-AzApplicationGatewayHttpListener -ApplicationGateway $AppGW `
                    -Name $80ListenerName `
                    -Protocol Http `
                    -FrontendIPConfiguration $AGFEIPConfig `
                    -FrontendPort $AGFEPort80 `
                    -HostName $ListenerURL `
                    | ConvertTo-Csv -NoTypeInformation
                if ($result -like "*Succeeded*") {Write-Host "Port 80 Listener Created" @success_color}
                $AGListener80 = Get-AzApplicationGatewayHttpListener -ApplicationGateway $AppGW -Name $80ListenerName
                #Add Port 443 Listener
                $result = Add-AzApplicationGatewayHttpListener `
                    -ApplicationGateway $AppGW -Name $ListenerName `
                    -Protocol Https `
                    -FrontendIPConfiguration $AGFEIPConfig `
                    -FrontendPort $AGFEPort443 `
                    -HostName $ListenerURL `
                    -RequireServerNameIndication true `
                    -SslCertificate $AGFECert `
                    | ConvertTo-Csv -NoTypeInformation
                if ($result -like "*Succeeded*") {Write-Host "Port 443 Listener Created" @success_color}
                $AGListener443 = Get-AzApplicationGatewayHttpListener -ApplicationGateway $AppGW -Name $ListenerName

                #Add Health Probe
                
                $match = New-AzApplicationGatewayProbeHealthResponseMatch -StatusCode 200-404
                if ($mode -eq "PaaS") {
                    $result = Add-AzApplicationGatewayProbeConfig `
                        -name $ListenerName `
                        -ApplicationGateway $AppGW `
                        -Protocol Https `
                        -Path /  `
                        -Interval 30 `
                        -Timeout 30 `
                        -UnhealthyThreshold 3 `
                        -HostName $BackendTarget `
                        -Match $match `
                        | ConvertTo-Csv -NoTypeInformation
                    if ($result -like "*Succeeded*") {Write-Host "PaaS Health Probe Created" @success_color}
                } else {
                    $result = Add-AzApplicationGatewayProbeConfig `
                        -name $ListenerName `
                        -ApplicationGateway $AppGW `
                        -Protocol Https `
                        -Path /  `
                        -Interval 30 `
                        -Timeout 30 `
                        -UnhealthyThreshold 3 `
                        -HostName $ListenerUrl `
                        -Match $match `
                        | ConvertTo-Csv -NoTypeInformation
                        #-PickHostNameFromBackendHttpSettings `
                    if ($result -like "*Succeeded*") {Write-Host "IaaS Health Probe Created" @success_color}
                }
                
                $AGHP = Get-AzApplicationGatewayProbeConfig -name $ListenerName -ApplicationGateway $AppGW

                #Add Backend Address Pool
                $result = Add-AzApplicationGatewayBackendAddressPool `
                    -ApplicationGateway $AppGW `
                    -Name $ListenerName `
                    -BackendIPAddresses $BackendTarget `
                    | ConvertTo-Csv -NoTypeInformation
                if ($result -like "*Succeeded*") {Write-Host "Backend Pool Created" @success_color}
                $AGBEP = Get-AzApplicationGatewayBackendAddressPool -ApplicationGateway $AppGW -Name $ListenerName

                #Add Backend HTTP Settings
                if ($mode -eq "PaaS") {
                    #PaaS HTTP Settings
                    $result = Add-AzApplicationGatewayBackendHttpSettings `
                        -ApplicationGateway $AppGW `
                        -Name $ListenerName `
                        -Port 443 `
                        -RequestTimeout 30 `
                        -Protocol Https `
                        -CookieBasedAffinity Enabled `
                        -AffinityCookieName $ListenerName `
                        -Probe $AGHP `
                        -PickHostNameFromBackendAddress `
                        | ConvertTo-Csv -NoTypeInformation
                    if ($result -like "*Succeeded*") {Write-Host "PaaS HTTP Settings Created" @success_color}
                    $AGHTTP = Get-AzApplicationGatewayBackendHttpSettings -ApplicationGateway $AppGW -Name $ListenerName
                } else {
                    #IaaS HTTP Settings
                    $result = Add-AzApplicationGatewayBackendHttpSettings `
                        -ApplicationGateway $AppGW `
                        -Name $ListenerName `
                        -Port 443 `
                        -Protocol Https `
                        -CookieBasedAffinity Enabled `
                        -AffinityCookieName $ListenerName `
                        -Probe $AGHP `
                        -HostName $ListenerUrl `
                        | ConvertTo-Csv -NoTypeInformation
                    if ($result -like "*Succeeded*") {Write-Host "IaaS HTTP Settings Created" @success_color}
                    $AGHTTP = Get-AzApplicationGatewayBackendHttpSettings -ApplicationGateway $AppGW -Name $ListenerName
                }

                #Create 80-2-443 Redirection Configuration
                $result = Add-AzApplicationGatewayRedirectConfiguration `
                    -Name $80ListenerName `
                    -RedirectType Permanent `
                    -TargetListener $AGListener443 `
                    -IncludePath $true `
                    -IncludeQueryString $true `
                    -ApplicationGateway $AppGW `
                    | ConvertTo-Csv -NoTypeInformation
                if ($result -like "*Succeeded*") {Write-Host "Redirect Configuration Created" @success_color}
                $redirectConfig = Get-AzApplicationGatewayRedirectConfiguration `
                    -Name $80ListenerName `
                    -ApplicationGateway $AppGW
                #Add SSL Redirect Routing Rule
                $result = Add-AzApplicationGatewayRequestRoutingRule `
                    -Name $80ListenerName `
                    -RuleType Basic `
                    -HttpListener $AGListener80 `
                    -RedirectConfiguration $redirectConfig `
                    -ApplicationGateway $AppGW `
                    | ConvertTo-Csv -NoTypeInformation
                if ($result -like "*Succeeded*") {Write-Host "SSL Redirect Rule Created" @success_color}
                #Add Default Root URL Path Map Config
                $rootPathRule = New-AzApplicationGatewayPathRuleConfig `
                    -Name "root" `
                    -Paths "/*" `
                    -BackendAddressPool $AGBEP `
                    -BackendHttpSettings $AGHTTP
                $result = Add-AzApplicationGatewayUrlPathMapConfig `
                    -ApplicationGateway $AppGW `
                    -Name $ListenerName `
                    -PathRules $rootPathRule `
                    -DefaultBackendAddressPool $AGBEP `
                    -DefaultBackendHttpSettings $AGHTTP `
                    | ConvertTo-Csv -NoTypeInformation
                if ($result -like "*Succeeded*") {Write-Host "URL Map Created" @success_color}
                $AGUPMC = Get-AzApplicationGatewayUrlPathMapConfig -ApplicationGateway $AppGW -Name $ListenerName
                #Add Routing Rule
                $result = Add-AzApplicationGatewayRequestRoutingRule `
                    -ApplicationGateway $AppGW  `
                    -Name $ListenerName  `
                    -RuleType PathBasedRouting  `
                    -BackendHttpSettings $AGHTTP  `
                    -HttpListener $AGListener443  `
                    -BackendAddressPool $AGBEP `
                    -UrlPathMap $AGUPMC `
                    | ConvertTo-Csv -NoTypeInformation
                if ($result -like "*Succeeded*") {Write-Host "Routing Rule Created" @success_color}
                
                $output = Set-AzApplicationGateway -ApplicationGateway $AppGW
                Write-Host ""
                Write-Host "Completed Updating App Gateway!" @success_color

            }
        }
    } 
}