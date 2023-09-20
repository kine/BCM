function SetInstance {
    $Instance = SelectInstance
    Set-Variable -Name ActiveInstance -Value $Instance.ServerInstance -Scope Global
    Set-Variable -Name ActiveVersion -Value $Instance.Version -Scope Global
}

RegisterFunction -Function 'SetInstance' -Name 'Set Active Instance' -NewShell $false
