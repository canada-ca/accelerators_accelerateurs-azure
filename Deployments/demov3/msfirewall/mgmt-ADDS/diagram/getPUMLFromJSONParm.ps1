# Ex: .\cleantemplate.ps1 ..\parameters\masterdeploy.parameters.json -outFileName dependsOn.puml
Param(
    [string]$inFileName = "",
    [string]$outFileName = ""
)

$tmp = New-TemporaryFile
$tmp2 = New-TemporaryFile

Set-Content -Path $outFileName -Value (get-content -Path $inFileName | Select-String -Pattern '"location":' -NotMatch |
Select-String -Pattern '"templateLink":' -NotMatch | Select-String -Pattern '"parametersFile":' -NotMatch | `
Select-String -Pattern '{' -NotMatch | Select-String -Pattern '}' -NotMatch | `
Select-String -Pattern '\[' -NotMatch | Select-String -Pattern '\]' -NotMatch | `
Select-String -Pattern '"\$schema":' -NotMatch | Select-String -Pattern '"contentVersion":' -NotMatch )

((Get-Content -path $outFileName -raw) -replace '"name": "', 'artifact ') | Set-Content -Path $outFileName
((Get-Content -path $outFileName -raw) -replace '",', '') | Set-Content -Path $outFileName
((Get-Content -path $outFileName -raw) -replace '-', '_') | Set-Content -Path $outFileName
((Get-Content -path $outFileName -raw) -replace '"', '') | Set-Content -Path $outFileName
((Get-Content -path $outFileName -raw) -replace '                    ', '') | Set-Content -Path $outFileName
((Get-Content -path $outFileName -raw) -replace "`r`n`r`n", '') | Set-Content -Path $outFileName

Set-Content -Path $tmp.FullName -Value (get-content -Path $outFileName | Select-String -Pattern 'artifact ' )
((Get-Content -path $outFileName -raw) -replace 'artifact ', '') | Set-Content -Path $outFileName
((Get-Content -path $outFileName -raw) -replace "`r`n    ", ' --> ') | Set-Content -Path $outFileName

"@startuml`n" | Out-File $tmp2.FullName
Get-Content -Path $tmp.FullName | Out-File $tmp2.FullName -Append
""  | Out-File $tmp2.FullName -Append
Get-Content -Path $outFileName | Out-File $tmp2.FullName -Append
"@enduml"  | Out-File $tmp2.FullName -Append
Get-Content -Path $tmp2.FullName | Set-Content $outFileName