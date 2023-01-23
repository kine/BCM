function StartInstances
{
    $Instances = SelectInstance -Multiple $True

    if ($Instances) {
        try {
            foreach($Instance in $instances){
                $Modules = GetModules -Version $Instance.Version
                $Script= {
                    param ($Modules,$Instance)
                    Import-Module $Modules -Scope Local
                    Write-Host "Starting $Instance" -ForegroundColor Green
                    Start-NAVServerInstance -ServerInstance $Instance -Force
                }
                Invoke-Command -ComputerName . -ScriptBlock $Script -ArgumentList $Modules,$Instance.ServerInstance
            }
        } finally {
            Read-Host "Press enter to continue"
        }
    }
}

RegisterFunction -Function 'StartInstances' -Name 'Start Instances'