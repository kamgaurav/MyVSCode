# Check crashed file in 192.168.68.37/38/39

$d = (Get-Date).AddDays(-3)
# $d.Date

Get-ChildItem -Path C:\flx-auto\DMServer\config | Where-Object {$_.LastWriteTime -ge ($d.Date)} 

# Get file between two dates

$d1 = (Get-Date).AddDays(-4)
$d2 = (Get-Date).AddDays(-3)

Get-ChildItem -Path C:\flx-auto\DMServer\config | Where-Object {$_.LastWriteTime -ge ($d1.Date) -and $_.LastWriteTime -le ($d2.Date)} 

# Check bad files in 192.168.70.193
# Get timstamp from above step, add/subtract a minute from it and input to below code. Give a time period of 1 or 2 minute

$dir = Get-ChildItem -Path T:\TypeBMsg\1A\in -Directory
$d = (Get-Date).AddDays(-3)

foreach ($c in $dir) {
    Get-ChildItem -Path $c.FullName | Where-Object {$_.LastWriteTime -ge ($d.Date) }
}
