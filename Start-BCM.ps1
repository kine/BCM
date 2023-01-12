<#
.SYNOPSIS
Script to manage Business Central instances

.DESCRIPTION
Show menu with functions and allows admin to select which function to run

.PARAMETER Version
Set which version of Management libraries to load. If empty, Latest is used. Example: 17.0

.EXAMPLE
.\Start-BCM.ps1 -Version 17.0

#>
param(
    [Parameter(Mandatory=$false)]
    [String]$Version = ''
)

<#
.SYNOPSIS
Register new function into the menu

.DESCRIPTION
Add item into main menu and set which function to call when selected

.PARAMETER Function
Name of the function which will be called when menu item is selected (no parameters are passed)

.PARAMETER Name
Description to show in the menu

.EXAMPLE
RegisterFunction -Function 'Exit' -Name 'Exit'

#>
function RegisterFunction
{
    param($Function,$Name)
    Write-Host "Registering function $Function with name $Name"
    Set-Variable -Name MenuItems -Value ($MenuItems + @{Function=$Function;Name=$Name}) -scope Global
}

Set-Variable -Name MenuItems -Value @() -Scope Global

Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Exclude Start-BCM.ps1 -Recurse | ForEach-Object {Write-Host "Executing $($_.Name)";. "$($_.FullName)"}

Import-Module (Get-ChildItem -Path 'C:\Program Files\Microsoft Dynamics 365 Business Central' -Include 'Microsoft.Dynamics.Nav.Management.dll' -Recurse | Where-Object {$_.VersionInfo.ProductVersion -like "$Version*"} | Sort-Object -Property LastWriteTime | Select-Object -Last 1)
Import-Module (Get-ChildItem -Path 'C:\Program Files\Microsoft Dynamics 365 Business Central' -Include 'Microsoft.Dynamics.Nav.Apps.Management.dll' -Recurse | Where-Object {$_.VersionInfo.ProductVersion -like "$Version*"} | Sort-Object -Property LastWriteTime | Select-Object -Last 1)

Set-Variable -Name ActiveInstance -Value '' -Scope Global
$Choice = ''

RegisterFunction -Function 'Exit' -Name 'Exit'

do {
    Write-Host "Displaying menu"
    $Choice = $MenuItems | Select-Object -property @{Label="Function";Expression={($_.Function)}},@{Label="Description";Expression={($_.Name)}} | Out-GridView -Title "Choice (Active instance: '$ActiveInstance')" -OutputMode Single

    if ($Choice -and ($Choice.Function -ne 'Exit')) {
        $FunctionName = $Choice.Function
        Write-Host "Running function $FunctionName"
        &$FunctionName
    }

} until ((-not $Choice) -or ($Choice.Function -eq 'Exit'))
