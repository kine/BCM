function Restart
{
    $Instance = GetActiveInstance -LoadModules

    if ($Instance) {
        try {
            Write-Host "Restarting $Instance"
            Restart-NAVServerInstance -ServerInstance $Instance -Force
        } finally {
            Read-Host "Press enter to continue"
        }
    }
}

RegisterFunction -Function 'Restart' -Name 'Restart Instance'