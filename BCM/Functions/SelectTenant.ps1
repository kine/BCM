function SelectTenant
{
    param(
        $Instance
        )
    $Tenants = Get-NAVTenant -ServerInstance $Instance
    if ($Tenants.Count -eq 1) {
        $Tenant = $Tenants[0]
    } else {
        $Tenant = $Tenants  | Out-GridView -Title "Select Tenant" -PassThru
    }
    Write-Host "Tenant Selected: $($Tenant.TenantId)"
    return $Tenant
}