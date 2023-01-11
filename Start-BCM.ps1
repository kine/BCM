# Script to manage BC instances. Replace the GUI MMC console snapin
param(
    [Parameter(Mandatory=$false)]
    [String]$Version = ''
)

function RegisterFunction
{
    param($Function,$Name)
    Write-Host "Registering function $Function with name $Name"
    Set-Variable -Name MenuItems -Value ($MenuItems + @{Function=$Function;Name=$Name}) -scope Global
}
function SelectInstance
{
    $Instances = Get-NavServerInstance
    $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Single
    return $Instance.ServerInstance
}

function SetInstance
{
    Set-Variable -Name ActiveInstance -Value (SelectInstance) -Scope Global
}

Set-Variable -Name MenuItems -Value @() -Scope Global

Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Exclude Start-BCM.ps1 -Recurse | ForEach-Object {Write-Host "Executing $($_.Name)";. "$($_.FullName)"}

Import-Module (Get-ChildItem -Path 'C:\Program Files\Microsoft Dynamics 365 Business Central' -Include 'Microsoft.Dynamics.Nav.Management.dll' -Recurse | Where-Object {$_.VersionInfo.ProductVersion -like "$Version*"} | Sort-Object -Property LastWriteTime | Select-Object -Last 1)
Import-Module (Get-ChildItem -Path 'C:\Program Files\Microsoft Dynamics 365 Business Central' -Include 'Microsoft.Dynamics.Nav.Apps.Management.dll' -Recurse | Where-Object {$_.VersionInfo.ProductVersion -like "$Version*"} | Sort-Object -Property LastWriteTime | Select-Object -Last 1)

Set-Variable -Name ActiveInstance -Value '' -Scope Global
$Choice = ''

RegisterFunction -Function 'SetInstance' -Name 'Select Instance'
RegisterFunction -Function 'Exit' -Name 'Exit'

do {
    $Choice = $Items |Select-Object -property @{Label="Function";Expression={($_.Function)}},@{Label="Description";Expression={($_.Name)}} | Out-GridView -Title "Choice (Active instance: '$ActiveInstance')" -OutputMode Single

    if ($Choice.Function -ne 'Exit') {
        $FunctionName = $Choice.Function
        Write-Host "Running function $FunctionName"
        &$FunctionName
    }

} until ((-not $Choice) -or ($Choice.Function -eq 'Exit'))
