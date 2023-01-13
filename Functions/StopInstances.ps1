function StopInstances
{
    $Instance = GetActiveInstance -LoadModules

    if ($Instances) {
        foreach($Instance in $instances){
            Write-Host "Stop $Instance"
            Stop-NAVServerInstance -ServerInstance $Instance -Force
            Read-Host "Press enter to continue"
        }
    }
}

RegisterFunction -Function 'StopInstances' -Name 'Stop Instances'