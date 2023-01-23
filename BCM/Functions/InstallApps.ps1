function InstallApps {
    $Instance = GetActiveInstance -LoadModules

    if ($Instance) {
        $Tenant = SelectTenant -Instance $Instance
        try {

            if ($Tenant) {
                $Apps = Get-NAVAppInfo -ServerInstance $Instance -Tenant $Tenant.Id -TenantSpecificProperties | where-object {-not $_.IsInstalled}
                $AppsToInstall = $Apps | Out-GridView -Title "Select Apps to Install" -OutputMode Multiple
                foreach($App in $AppsToInstall){
                    if ($App.NeedsUpgrade) {
                        Write-Host "Upgrading $($App.Name) to version $($App.Version)" -ForegroundColor Green
                        $App | Start-NAVAppDataUpgrade -ServerInstance $Instance -Tenant $Tenant.Id -Force
                    } else {
                        Write-Host "Installing $($App.Name) version $($App.Version)" -ForegroundColor Green
                        $App | Install-NAVApp -ServerInstance $Instance -Tenant $Tenant.Id -Force
                    }
                }
            }
        } finally {
            Read-Host "Press enter to continue"
        }

    }


}

RegisterFunction -Function 'InstallApps' -Name 'Install apps' -NewShell $true