#Function for creating new NavWebInstance
function NewWebInstance
{
    $Instance = GetActiveInstance -LoadModules
    if ($Instance) {
        $Modules = GetModules -Version $Instance.Version
        $Script= {
            param ($Modules,$Instance)
            Import-Module $Modules -Scope Local
            Write-Host "Creating Web Instance for $Instance"
            New-NAVWebServerInstance -ServerInstance $Instance -Force
        }
        Invoke-Command -ComputerName . -ScriptBlock $Script -ArgumentList $Modules,$Instance.ServerInstance
    }
}
 