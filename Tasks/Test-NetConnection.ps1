$c = Read-Host "Enter Server Name"
$port =  Read-Host "Enter Port No."
Test-NetConnection -ComputerName $c -Port $port