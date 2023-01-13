function GetActiveInstance
{
    param([Switch]$LoadModules)
    if (-not $ActiveInstance) {
        $Instance = SelectInstance
        $Version = $Instance.Version
        Set-Variable -Name ActiveInstance -Value $Instance.ServerInstance -Scope Global
        Set-Variable -Name ActiveVersion -Value $Instance.Version -Scope Global
        $Instance = $Instance.ServerInstance
    } else {
        $Instance = $ActiveInstance
        $Version = $ActiveVersion
    }

    if ($LoadModules) {
        LoadModules -Version $Version
    }
    Return $Instance
}