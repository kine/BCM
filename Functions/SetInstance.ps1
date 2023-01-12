function SetInstance
{
    Set-Variable -Name ActiveInstance -Value (SelectInstance) -Scope Global
}

RegisterFunction -Function 'SetInstance' -Name 'Set Active Instance'
