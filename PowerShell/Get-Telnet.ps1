$ip = Read-Host "Enter IP Address"
[int]$port = Read-Host "Enter Port No."


$Socket = New-Object System.Net.Sockets.TcpClient
$Socket.Connect("$ip", $port)
$Socket.Connected