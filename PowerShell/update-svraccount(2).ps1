$service = Get-WmiObject -Class Win32_Service -ComputerName "Test-PC" | Where-Object {($_.StartName -eq ".\admin")}

foreach ($svr in $service) {


$stopsvr = $svr.stopservice()

while ($stopsvr.returnvalue -ne "0") {

    Write-Host ""$svr.name" is stopping"
    Start-Sleep -Seconds 15
}
}