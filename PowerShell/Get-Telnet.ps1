$ip = Read-Host "Enter IP Address"
[int]$port = Read-Host "Enter Port No."


[int]$ip = 172.23.228.226
[int]$port = 17778

$Socket = New-Object System.Net.Sockets.TcpClient
$Socket.Connect("$ip", $port)
$Socket.Connected

Test-NetConnection -ComputerName 172.23.228.226 -Port 17778
