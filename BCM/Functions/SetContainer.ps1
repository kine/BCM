function SetContainer {
    $Container = SelectContainer
    Set-Variable -Name ActiveContainer -Value $Container.Container -Scope Global
    Set-Variable -Name ActiveVersion -Value $Container.Version -Scope Global
}

RegisterFunction -Function 'SetContainer' -Name 'Set Active Container' -NewShell $false -Docker $true
