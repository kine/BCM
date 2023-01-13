function StartInstances
{
    $Instance = GetActiveInstance -LoadModules

    if ($Instances) {
        foreach($Instance in $instances){
            Write-Host "Starting $Instance"
            Start-NAVServerInstance -ServerInstance $Instance -Force
            Read-Host "Press enter to continue"
        }
    }
}

RegisterFunction -Function 'StartInstances' -Name 'Start Instances'