<# 
AzureUserManagement.ps1
by Ken Morency <ken.morency@tc.gc.ca>
from https://github.com/KenMorencyTC/TC-Cloud-Team-Automation-Scripting
version 0.2b - June 6, 2019

This program/script is free software: you can redistribute it and/or modify it under the terms of
the GNU General Public License as published by the Free Software Foundation, either version
3 of the License.  This program/script is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program/script.
If not, see <https://www.gnu.org/licenses/gpl-3.0.en.html>.

This script can bulk create azure AD accounts based on your departmental list.

The script also gives you the ability to assign or remove licenses for users. The available licenses can be adjusted manually within the script.

Your bulk list of emails (*.txt, *.csv) should be listed one per line like:

first.last@yourdept.gc.ca
last.first@yourdept.gc.ca
f.last@yourdept.gc.ca

Update the variables below to set your dept suffix and azure tenant suffix.
#> 


#### --  INIT VARS -- ####
# Safe to Edit #
$app_title="==== AZURE/M365 USER & LICENSE MANAGEMENT ===="
$dep_title="===== YourDept Canada Cloud Operations ======"
$depart_email="@yourdept.gc.ca"
$devops_email="@000gc.onmicrosoft.com"
$user_tmppwd = "YourTempPass"
$title_color = @{ForegroundColor = "cyan"}
$option_color = @{ForegroundColor="blue"; BackgroundColor="white"}
$success_color = @{ForegroundColor = "green"}
$select_color = @{ForegroundColor = "cyan"}
$error_color = @{ForegroundColor = "red"}
# End Safe to Edit #

# Edit below with care #
Add-Type -AssemblyName System.Windows.Forms
$users=$null
$user_email=$null

#### -- FUNCTIONS -- ####

function MSOLConnected {
    Get-MsolDomain -ErrorAction SilentlyContinue | out-null
    $result = $?
    return $result
}

function UserCreate
{
    param ([String] $filePath) 

    $users = Import-Csv $filePath -Header "Email"
    foreach ($user in $users)
    {
        $user_email=$user.Email
        $user_email=$user_email.Trim()
        if (ValidateEmail($user_email) -eq $true) {
            AddUser($user_email)
        } else {
            Write-Host "Invalid Email Address: $user_email. Please try again." @error_color
        }
    }
}

function MultiUserLicense
{
    param ([String]$filePath, [String]$user_license) 

    Write-Host $filepath
    $users = Import-Csv $filePath -Header "Email"
    foreach ($user in $users)
    {
        $user_email=$user.Email
        $user_email=$user_email.Trim()
        if (ValidateEmail($user_email) -eq $true) {
            AssignLicense $user_email $user_license
        } else {
            Write-Host "Invalid Email Address: $user_email. Please try again." @error_color
        }
    }
}

function IndvidualUserLicense
{
    param ([String] $filePath, [String] $user_license) 

    $users = Import-Csv $filePath -Header "Email"
    foreach ($user in $users)
    {
        $user_email=$user.Email
        $user_email=$user_email.Trim()
        $user_prefix=$user_email.Split("@")[0]
        $user_name=(Get-Culture).textinfo.totitlecase($user_prefix.replace("."," "))
        #$user_TCEmail=$user_prefix + $depart_email
        #$user_OCEmail=$user_prefix + $devops_email
        if (ValidateEmail($user_email) -eq $true) {
            Show-LicenseMenu
            Write-Host "Please make a selection for $user_name" @success_color
            $mode_license = ""
            $mode_license = Read-Host
            switch ($mode_license)
            {
                '1' {
                    #No License
                    Write-Host "No License Assigned!" @error_color
                } '' {
                    #No License
                    Write-Host "No License Assigned!" @error_color
                } '2' {
                    #034gc:ENTERPRISEPACK
                    AssignLicense  $user_email "034gc:ENTERPRISEPACK"
                } '3' {
                    #034gc:DYN365_TEAM_MEMBERS
                    AssignLicense $user_email "034gc:DYN365_TEAM_MEMBERS"
                } '4' {
                    #034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT
                    AssignLicense $user_email "034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT"
                } '5' {
                    #034gc:SMB_APPS
                    AssignLicense $user_email "034gc:SMB_APPS"
                } 'q' {
                    exit
                }
            }
        } else {
            Write-Host "Invalid Email Address: $user_email. Please try again." @error_color
        }
    }
}

function AddUser {
    param (
        [string]$email
    ) 
    $email=$email.Trim()
    $user_prefix=$email.Split("@")[0]
    $user_name=(Get-Culture).textinfo.totitlecase($user_prefix.replace("."," "))
    $user_TCEmail=$user_prefix + $depart_email
    $user_OCEmail=$user_prefix + $devops_email

     #Write-Host "New-MsolUser -UserPrincipalName `"$user_OCEmail`" -DisplayName `"$user_name`" -AlternateEmailAddresses `"$user_TCEmail`" -Password `"$user_tmppwd`""
    New-MsolUser -UserPrincipalName "$user_OCEmail" -DisplayName "$user_name" -AlternateEmailAddresses "$user_TCEmail" -Password "$user_tmppwd"
    Write-Host "Account $user_OCEmail created with temporary password: $user_tmppwd" @success_color
}
function AssignLicense {
    param ($email,$license) 
    $email=$email.Trim()
    $user_prefix=$email.Split("@")[0]
    $user_OCEmail=$user_prefix + $devops_email
    $user_usgloc="CA"
    $user_SKU=$license

    #Write-Host "Set-MsolUser -UserPrincipalName `"$user_OCEmail`" -UsageLocation `"$user_usgloc`""
    #Write-Host "Set-MsolUserLicense -UserPrincipalName `"$user_OCEmail`" -AddLicenses `"$user_SKU`""
    Set-MsolUser -UserPrincipalName "$user_OCEmail" -UsageLocation "$user_usgloc"
    Set-MsolUserLicense -UserPrincipalName "$user_OCEmail" -AddLicenses "$user_SKU"
    Write-Host "$license assigned to $user_OCEmail" @success_color
}
function RemoveLicense {
    param ($email,$license)
    $email=$email.Trim()
    $user_prefix=$email.Split("@")[0]
    $user_OCEmail=$user_prefix + $devops_email
    $user_usgloc="CA"
    $user_SKU=$license

    #Write-Host "Set-MsolUser -UserPrincipalName `"$user_OCEmail`" -UsageLocation `"$user_usgloc`""
    #Write-Host "Set-MsolUserLicense -UserPrincipalName `"$user_OCEmail`" -RemoveLicenses `"$user_SKU`""
    Set-MsolUser -UserPrincipalName "$user_OCEmail" -UsageLocation "$user_usgloc"
    Set-MsolUserLicense -UserPrincipalName "$user_OCEmail" -RemoveLicenses "$user_SKU"
    Write-Host "$license assigned to $user_OCEmail" @success_color
}
function OpenFile
{
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = $PSCommandPath
        Filter = 'Comma Separated Values File (*.csv)|*.csv|Text File (*.txt)|*.txt'
         }
    $null = $FileBrowser.ShowDialog()
    return $FileBrowser.FileName
}

function ValidateEmail {
    param ($email)
    $email_regex = "^([\w-\.\']+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$"

    $isMatch = $email -match $email_regex
    if ($isMatch) {
        return $true
    }
    else {
        return $false
    }
}


### MENUS ###
function Show-MainMenu
{
    Write-Host ""
    Write-Host "Choose Management Mode:" @option_color
    Write-Host "1: Press '1' Per User (One At A Time)"
    Write-Host "2: Press '2' Multiple Users (Bulk From CSV/TXT File)"
    Write-Host "Q: Press 'Q' to quit."
    Write-Host ""
}
function Show-PerUserMenu
{
    Write-Host ""
    Write-Host "Choose Licensing Option" @option_color
    Write-Host "1: Press '1' Add User(s)"
    Write-Host "2: Press '2' Set License For User(s)"
    Write-Host "3: Press '3' Add User(s) & Set License"
    Write-Host "4: Press '4' Remove License From User(s)"
    Write-Host "Q: Press 'Q' to quit."
    Write-Host ""
}
function Show-MultiUserMenu
{
    Write-Host ""
    Write-Host "Choose Licensing Option" @option_color
    Write-Host "1: Press '1' Add Users"
    Write-Host "2: Press '2' Set License For Users"
    Write-Host "3: Press '3' Set License For Users Individually"
    Write-Host "4: Press '4' Add Users & Set Licenses"
    Write-Host "5: Press '5' Add Users & Set Licenses Individually"
    Write-Host "Q: Press 'Q' to quit."
    Write-Host ""
}
function Show-LicenseMenu
{
    Write-Host ""
    Write-Host "Choose License" @option_color
    Write-Host "1: Enter '1' No License"
    Write-Host "2: Press '2' Microsoft 365 E3" #034gc:ENTERPRISEPACK
    Write-Host "3: Enter '3' Dynamics Team Member" #034gc:DYN365_TEAM_MEMBERS
    Write-host "4: Enter '4' Dynamics 365 Case Management Enterprise Edition" #034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT
    Write-Host "5: Enter '5' Microsoft Business Apps" #034gc:SMB_APPS
    <# Write-Host "3: Enter '3' STREAM"
    Write-Host "4: Enter '4' ENTERPRISEPACKWITHOUTPROPLUS"
    Write-Host "5: Enter '5' DYN365_ENTERPRISE_CASE_MANAGEMENT"
    Write-Host "6: Enter '6' DYN365_TEAM_MEMBERS"
    Write-Host "7: Enter '7' ENTERPRISEPACK"
    Write-Host "8: Enter '8' PROJECTESSENTIALS"
    Write-Host "9: Enter '9' FLOW_FREE"
    Write-Host "10: Enter '10' PROJECTPREMIUM"
    Write-Host "11: Enter '11' Win10_VDA_E3"
    Write-Host "12: Enter '12' FORMS_PRO"
    Write-Host "13: Enter '13' POWERAPPS_VIRAL"
    Write-Host "14: Enter '14' DYN365_ENTERPRISE_P1_IW"
    Write-Host "15: Enter '15' MS_TEAMS_IW"
    Write-Host "16: Enter '16' DYN365_ENTERPRISE_PLAN1"
    Write-Host "17: Enter '17' POWER_BI_STANDARD"
    Write-Host "18: Enter '18' OFFICESUBSCRIPTION"
    Write-Host "19: Enter '19' EMS"
    Write-Host "20: Enter '20' PROJECTPROFESSIONAL"
    Write-Host "21: Enter '21' TEAMS_COMMERCIAL_TRIAL"
    Write-Host "22: Enter '22' ATP_ENTERPRISE" #>
    Write-Host "Q: Press 'Q' Quit"
    Write-Host ""
}
function Show-RemoveLicenseMenu
{
    Write-Host ""
    Write-Host "Choose License to Remove" @option_color
    Write-Host "1: Enter '1' None"
    Write-Host "2: Press '2' Microsoft 365 E3" #034gc:ENTERPRISEPACK
    Write-Host "3: Enter '3' Dynamics Team Member" #034gc:DYN365_TEAM_MEMBERS
    Write-host "4: Enter '4' Dynamics 365 Case Management Enterprise Edition" #034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT
    Write-Host "5: Enter '5' Microsoft Business Apps" #034gc:SMB_APPS
    <# Write-Host "3: Enter '3' STREAM"
    Write-Host "4: Enter '4' ENTERPRISEPACKWITHOUTPROPLUS"
    Write-Host "5: Enter '5' DYN365_ENTERPRISE_CASE_MANAGEMENT"
    Write-Host "6: Enter '6' DYN365_TEAM_MEMBERS"
    Write-Host "7: Enter '7' ENTERPRISEPACK"
    Write-Host "8: Enter '8' PROJECTESSENTIALS"
    Write-Host "9: Enter '9' FLOW_FREE"
    Write-Host "10: Enter '10' PROJECTPREMIUM"
    Write-Host "11: Enter '11' Win10_VDA_E3"
    Write-Host "12: Enter '12' FORMS_PRO"
    Write-Host "13: Enter '13' POWERAPPS_VIRAL"
    Write-Host "14: Enter '14' DYN365_ENTERPRISE_P1_IW"
    Write-Host "15: Enter '15' MS_TEAMS_IW"
    Write-Host "16: Enter '16' DYN365_ENTERPRISE_PLAN1"
    Write-Host "17: Enter '17' POWER_BI_STANDARD"
    Write-Host "18: Enter '18' OFFICESUBSCRIPTION"
    Write-Host "19: Enter '19' EMS"
    Write-Host "20: Enter '20' PROJECTPROFESSIONAL"
    Write-Host "21: Enter '21' TEAMS_COMMERCIAL_TRIAL"
    Write-Host "22: Enter '22' ATP_ENTERPRISE" #>
    Write-Host "Q: Press 'Q' Quit"
    Write-Host ""
}

################# BEGIN UI  ######################

Clear-Host
if (-not (MSOLConnected)) {
    Connect-MsolService
}

$iQuit=$false

While ($iQuit -eq $false) {
    Write-Host ""
    Write-Host $app_title @title_color
    Write-Host $dep_title @title_color
    
    Show-MainMenu
    Write-Host "Please make a selection" @select_color
    $mode_run = Read-Host
    
    switch ($mode_run)
    {
        '1' {
            #Per User
            Show-PerUserMenu
            Write-Host "Please make a selection" @select_color
            $mode_perusr = Read-Host
    
            switch ($mode_perusr)
            {
                '1' {
                    #Add User(s)
                    $isDone=$false
                    while($isDone -eq $false){
                        Write-Host ""
                        Write-Host "Enter organization email address (ex. john.smith$depart_email) and hit Enter. Leave Blank to Finish." @select_color
                        $user_email = Read-Host
                        $user_email=$user_email.Trim()
                        if ($user_email -ne '') {
                            if (ValidateEmail($user_email) -eq $true) {
                                AddUser($user_email)
                            } else {
                                Write-Host "Invalid Email Address: $user_email. Please try again." @error_color
                            }
                        } else {
                            $isDone=$true
                        }
                    }
                    
                } '2' {
                    #Set License For User(s)
                    $isDone=$false
                    while($isDone -eq $false){
                        Write-Host ""
                        Write-Host "Enter organization email address (ex. john.smith$depart_email) and hit Enter. Leave Blank to Finish." @select_color
                        $user_email = Read-Host
                        $user_email=$user_email.Trim()
                        if ($user_email -ne '') {
                            if (ValidateEmail($user_email) -eq $true) {
                                Show-LicenseMenu
                                Write-Host "Please make a selection" @success_color
                                $mode_license = Read-Host
                                switch ($mode_license)
                                {
                                    '1' {
                                        #No License
                                        Write-Host "No License Assigned!" @error_color
                                    } '2' {
                                        #034gc:ENTERPRISEPACK
                                        AssignLicense $user_email "034gc:ENTERPRISEPACK"
                                    } '3' {
                                        #034gc:DYN365_TEAM_MEMBERS
                                        AssignLicense $user_email "034gc:DYN365_TEAM_MEMBERS"
                                    } '4' {
                                        #034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT
                                        AssignLicense $user_email "034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT"
                                    } '5' {
                                        #034gc:SMB_APPS
                                        AssignLicense $user_email "034gc:SMB_APPS"
                                    } 'q' {
                                        $iQuit = $true
                                    }
                                }
                            } else {
                                Write-Host "Invalid Email Address: $user_email. Please try again." @error_color
                            }
                        } else {
                            $isDone=$true
                        }
                    }
                } '3' {
                    #Add User(s) & Set License
                    $isDone=$false
                    while($isDone -eq $false){
                        Write-Host ""
                        Write-Host "Enter organization email address (ex. john.smith$depart_email) and hit Enter. Leave Blank to Finish." @select_color
                        $user_email = Read-Host
                        $user_email=$user_email.Trim()
                        if ($user_email -ne '') {
                            if (ValidateEmail($user_email) -eq $true) {
                                Show-LicenseMenu
                                Write-Host "Please make a selection" @success_color
                                $mode_license = Read-Host
                                switch ($mode_license)
                                {
                                    '1' {
                                        #No License
                                        Write-Host "No License Assigned!" @error_color
                                    } '2' {
                                        #034gc:ENTERPRISEPACK
                                        AddUser($user_email)
                                        AssignLicense $user_email "034gc:ENTERPRISEPACK"
                                    } '3' {
                                        #034gc:DYN365_TEAM_MEMBERS
                                        AddUser($user_email)
                                        AssignLicense $user_email "034gc:DYN365_TEAM_MEMBERS"
                                    } '4' {
                                        #034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT
                                        AddUser($user_email)
                                        AssignLicense $user_email "034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT"
                                    } '5' {
                                        #034gc:SMB_APPS
                                        AddUser($user_email)
                                        AssignLicense $user_email "034gc:SMB_APPS"
                                    } 'q' {
                                        $iQuit = $true
                                    }
                                }
                            } else {
                                Write-Host "Invalid Email Address: $user_email. Please try again." @error_color
                            }
                        } else {
                            $isDone=$true
                        }
                    }
                } '4' {
                    #Remove License from User
                    $isDone=$false
                    while($isDone -eq $false){
                        Write-Host ""
                        Write-Host "Enter organization email address (ex. john.smith$depart_email) and hit Enter. Leave Blank to Finish." @select_color
                        $user_email = Read-Host
                        $user_email=$user_email.Trim()
                        if ($user_email -ne '') {
                            if (ValidateEmail($user_email) -eq $true) {
                                Show-RemoveLicenseMenu
                                Write-Host "Please make a selection" @success_color
                                $mode_license = Read-Host
                                switch ($mode_license)
                                {
                                    '1' {
                                        #No License
                                        Write-Host "No License Removed!" @error_color
                                    } '2' {
                                        #034gc:ENTERPRISEPACK
                                        RemoveLicense $user_email "034gc:ENTERPRISEPACK"
                                    } '3' {
                                        #034gc:DYN365_TEAM_MEMBERS
                                        RemoveLicense $user_email "034gc:DYN365_TEAM_MEMBERS"
                                    } '4' {
                                        #034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT
                                        RemoveLicense $user_email "034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT"
                                    } '5' {
                                        #034gc:SMB_APPS
                                        RemoveLicense $user_email "034gc:SMB_APPS"
                                    } 'q' {
                                        $iQuit = $true
                                    }
                                }
                            } else {
                                Write-Host "Invalid Email Address: $user_email. Please try again." @error_color
                            }
                        } else {
                            $isDone=$true
                        }
                    }
                }
            }
        } '2' {
            #Multi User Management
            Show-MultiUserMenu
            Write-Host "Please make a selection" @select_color
            $mode_multusr = Read-Host
    
            switch ($mode_multusr)
            {
                '1' {
                    #Add Users
                    $filePath = OpenFile
                    UserCreate $filePath
                } '2' {
                    #Set License For Users
                    $filePath = OpenFile
                    Show-LicenseMenu
                    Write-Host "Please make a selection" @success_color
                    $mode_license = Read-Host
                    switch ($mode_license)
                    {
                        '1' {
                            #No License
                            Write-Host "No License Assigned!" @error_color
                        } '2' {
                            #034gc:ENTERPRISEPACK
                            MultiUserLicense $filepath "034gc:ENTERPRISEPACK"
                        } '3' {
                            #034gc:DYN365_TEAM_MEMBERS
                            MultiUserLicense $filepath "034gc:DYN365_TEAM_MEMBERS"
                        } '4' {
                            #034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT
                            MultiUserLicense $filepath "034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT"
                        } '5' {
                            #034gc:SMB_APPS
                            MultiUserLicense $filepath "034gc:SMB_APPS"
                        } 'q' {
                            $iQuit = $true
                        }
                    }
                } '3' {
                    #Set License For Users Individually
                    $filePath = OpenFile
                    IndvidualUserLicense $filepath
                } '4' {
                    #Add Users & Set Licenses
                    $filePath = OpenFile
                    UserCreate $filePath
                    Show-LicenseMenu
                    Write-Host "Please make a selection" @success_color
                    $mode_license = Read-Host
                    switch ($mode_license)
                    {
                        '1' {
                            #No License
                            Write-Host "No License Assigned!" @error_color
                        } '2' {
                            #034gc:ENTERPRISEPACK
                            MultiUserLicense $filepath "034gc:ENTERPRISEPACK"
                        } '3' {
                            #034gc:DYN365_TEAM_MEMBERS
                            MultiUserLicense $filePath "034gc:DYN365_TEAM_MEMBERS"
                        } '4' {
                            #034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT
                            MultiUserLicense $filePath "034gc:DYN365_ENTERPRISE_CASE_MANAGEMENT"
                        } '5' {
                            #034gc:SMB_APPS
                            MultiUserLicense $filePath "034gc:SMB_APPS"
                        } 'q' {
                            $iQuit = $true
                        }
                    }
                } '5' {
                    #Add Users & Set Licenses Individually
                    $filePath = OpenFile
                    UserCreate $filePath
                    IndvidualUserLicense $filepath
                }
            }
        } 'q' {
            $iQuit = $true
        }
    }
}
exit

