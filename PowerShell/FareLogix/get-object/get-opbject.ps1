$ErrorActionPreference = "SilentlyContinue"
$ComputerInfo = New-Object PSObject     

$Computer = Get-WmiObject -Class Win32_ComputerSystem
$IP= Get-NetIPAddress -AddressFamily IPv4 | where {$_.InterfaceAlias -notmatch 'Loopback'}
                    
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "ServerName" -Value $Computer.Name -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "IPAddress" -Value $IP.IPv4Address -Force

$ComputerInfo.ServerName
$ComputerInfo.IPAddress
