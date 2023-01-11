function GetInstances
{
    $Instances = Get-NavServerInstance
    $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Single
}

RegisterFunction -Function 'GetInstances' -Name 'Get Instances'
