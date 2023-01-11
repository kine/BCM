function RemoveInstance
{
    if (-not $ActiveInstance) {
        $Instance = SelectInstance
    } else {
        $Instance = $ActiveInstance
    }

    if ($Instance) {
        Add-Type -AssemblyName PresentationFramework
        $continue = [System.Windows.MessageBox]::Show("Are you sure that you want to remove instance $($Instance)?", 'Confirmation', 'YesNo');
        if ($continue -eq 'Yes') {
            Write-Host "Removing $Instance"
            Remove-NAVServerInstance -ServerInstance $Instance -Force
        }
    }
}

RegisterFunction -Function 'RemoveInstance' -Name 'Remove existing instance'