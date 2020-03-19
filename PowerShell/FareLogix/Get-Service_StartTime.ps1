$service = Get-CimInstance -ClassName Win32_Service | where { $_.DisplayName -match 'FLX*' }
$srv_uptime = @()
foreach ($s in $service) {
    $process = Get-CimInstance -ClassName Win32_Process -Filter "ProcessId = '$($p.ProcessId)'"

    $srv_uptime += [pscustomobject] [ordered] @{
        'Server_Name'       = $s.SystemName
        'Service_Name'      = $s.DisplayName
        'Service_State'     = $s.State
        'Service_StartTime' = $process.CreationDate
    }
}

$srv_uptime
