#There are two admin-tasks scripts

cls
write-host '###############################'
write-host '#                             #'
write-host '#       Admin Tasks           #'
write-host '#                             #'
write-host '#       1. Get Uptime         #'
write-host '#       2. Get Disk Space     #'
write-host '#       3. Get CPU & RAM      #'
write-host '#       4. Get Event Logs     #'
write-host '#       5. Get Telnet         #'
write-host '#       6. Exit               #'
write-host '#                             #'
write-host '#                             #'
write-host '###############################'
write-host ""
write-host ""

$c = read-host "Choose Admin Task"

cls

if ($c -eq 1)
{
# Get Uptime of Server

$os = Get-WmiObject -Class win32_operatingsystem
$c = get-date ($os.ConvertToDateTime($os.LastBootUpTime))
$d = get-date
write-host "System Uptime is:"
$d -$c | select days, Hours, Minutes | ft -AutoSize

}

elseif ($c -eq 2)

{
# Get Total & Free Disk Space

Get-WmiObject -Class win32_logicaldisk -Filter "DriveType = '3'" | 
select SystemName, DeviceID, @{Name='Total Space(GB)'; expression={[math]::round($_.Size / 1GB, 2 )}},
 @{Name='Free Space(GB)'; expression={[math]::round($_.Freespace / 1GB, 2)}}, 
 @{Name = '%Free'; expression = {[math]::round(($_.Freespace/$_.Size) * 100, 0)}} | FT -AutoSize
}

elseif ($c -eq 3) 

{
# Get CPU & RAM

Get-WmiObject -Class win32_computersystem | select NumberOfProcessors, NumberOfLogicalProcessors,
@{Name='RAM(GB)'; expression={[math]::round($_.TotalPhysicalMemory / 1GB)}} | ft -AutoSize

}


elseif ($c -eq 4)

# Get Event Logs
# will add -computername property later on

{

[string]$l = Read-Host "Choose Log Type, eg. Application, Security, System"
[string]$e = Read-Host "Specify Entry Tpe, eg. Information, Error, Warning"
[int]$n = Read-Host "Specify the max no. of events to retrieve, for eg. 10, 100, 200"
cls
Get-EventLog -LogName $l -EntryType $e -Newest $n
    
}

elseif ($c -eq 5)

{ 

$ip = Read-Host "Enter IP Address"
[int]$port = Read-Host "Enter Port No."

$Socket = New-Object System.Net.Sockets.TcpClient
$Socket.Connect("$ip", $port)
$Socket.Connected

}


elseif ($c -eq 6)

{ exit }

else 

{"Choose from Available Admin Tasks!"}

