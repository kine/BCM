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
    [String]$Version = '',
    [Parameter(Mandatory=$false)]
    [String]$Function = '',
    [Parameter(Mandatory=$false)]
    [String]$Instance = ''
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
    param($Function,$Name,[bool]$NewShell=$true)
    Write-Host "Registering function $Function with name $Name" -ForegroundColor Green
    Set-Variable -Name MenuItems -Value ($MenuItems + @{Function=$Function;Name=$Name;NewShell=$NewShell}) -scope Global
}

function RunFunction
{
    param(
        $Function,
        [Switch]$NewWindow
    )
    Write-Host "Running function $Function" -ForegroundColor Green
    if ($NewWindow) {
        if (-not $ActiveVersion) {
            $Version = "''"
        } else {
            $Version = $ActiveVersion
        }
        $Script = $MyInvocation.PSCommandPath
        if ($ActiveInstance) {
            $PSParams = @{
                FilePath     = "PowerShell.exe"
                ArgumentList = @(
                    "-File $Script -Version $Version -Instance $ActiveInstance -Function $Function"
                )
            }
        } else {
            $PSParams = @{
                FilePath     = "PowerShell.exe"
                ArgumentList = @(
                    "-File $Script -Version $Version -Function $Function"
                )
            }
        }
        Write-Host "Executing Start-Process with $($PSParams.ArgumentList)"
        Start-Process @PSParams -Wait
    } else {
        &$Function
    }
}

function GetModules
{
    param(
        $Version=''
    )
    $Modules = @()
    $Path = 'C:\Program Files\Microsoft Dynamics 365 Business Central'
    Write-Verbose "Looking into $Path for $Version"
    $Files = (Get-ChildItem -Path $Path -Include 'Microsoft.Dynamics.Nav.Management.dll' -Recurse | Where-Object {$_.VersionInfo.ProductVersion -like "$Version*"} | Sort-Object -Property LastWriteTime | Select-Object -Last 1)
    Write-Verbose "Found $Files"
    $Modules += $Files
    $Files = (Get-ChildItem -Path $Path -Include 'Microsoft.Dynamics.Nav.Apps.Management.dll' -Recurse | Where-Object {$_.VersionInfo.ProductVersion -like "$Version*"} | Sort-Object -Property LastWriteTime | Select-Object -Last 1)
    Write-Verbose "Found $Files"
    $Modules += $Files
    Return $Modules
}
function LoadModules
{
    param(
        $Version=''
    )
    $ModulesFiles = GetModules -Version $Version
    Write-Host "Loading modules for version $Version" -ForegroundColor Green
    Write-Host "$ModulesFiles" -ForegroundColor Green
    $Modules = $ModulesFiles
    Import-Module $Modules
}

Set-Variable -Name MenuItems -Value @() -Scope Global

Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Exclude Start-BCM.ps1 -Recurse | ForEach-Object {Write-Host "Executing $($_.Name)";. "$($_.FullName)"}

Set-Variable -Name ActiveInstance -Value '' -Scope Global
Set-Variable -Name ActiveVersion -Value '' -Scope Global

Write-Host "Version: $Version" -ForegroundColor Green
Write-Host "Instance: $Instance" -ForegroundColor Green
if ($Instance) {
    Write-Host "Setting ActiveInstance to $Instance"
    $ActiveInstance = $Instance
    Set-Variable -Name ActiveInstance -Value $Instance -Scope Global
}
if ($Version -eq "''") {
    $Version = ''
}
if ($Version) {
    Write-Host "Setting ActiveVersion to $Version"
    $ActiveVersion = $Version
    Set-Variable -Name ActiveVersion -Value $Version -Scope Global
}

$Choice = ''

#Load modules for latest version to be able to e.g. list instances

RegisterFunction -Function 'Exit' -Name 'Exit'

Write-Host "Function: $Function" -ForegroundColor Green
if ($Function) {
    try {
        RunFunction -Function $Function
    } catch {
        Read-Host "$_"
    }
} else {
    do {
        Write-Host "Displaying menu"
        $Choice = $MenuItems | Select-Object -property @{Label="Function";Expression={($_.Function)}},@{Label="Description";Expression={($_.Name)}},@{Label="InNewShell";Expression={($_.NewShell)}} | Out-GridView -Title "Choice (Active instance: '$ActiveInstance')" -OutputMode Single
        
        if ($Choice -and ($Choice.Function -ne 'Exit')) {
            $FunctionName = $Choice.Function
            RunFunction -Function $FunctionName -NewWindow:$Choice.InNewShell
        }
        
    } until ((-not $Choice) -or ($Choice.Function -eq 'Exit'))
}
    