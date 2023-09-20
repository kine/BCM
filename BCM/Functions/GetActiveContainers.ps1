function GetActiveContainers {
    if (-not $ActiveContainer) {
        $Container = SelectContainer
        $Version = $Container.Version
        Set-Variable -Name ActiveContainer -Value $Container.Container -Scope Global
        Set-Variable -Name ActiveVersion -Value $Version -Scope Global
        $Container = $Container.Container
    }
    else {
        $Container = $ActiveContainer
        $Version = $ActiveVersion
    }

    Return $Container
}