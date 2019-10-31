
#$service = Get-Service -DisplayName 'VMware NAT Service' | Select-Object -ExpandProperty name
#$svr = gwmi win32_service -computername Test-PC -filter "name= '$service'"
#$svr.Change($null,$null,$null,$null,$null,$null,"test-pc\admin","Test@1234")

$service = Get-WmiObject -Class Win32_Service -ComputerName "gauravkam" | Where-Object {($_.StartName -eq "fareast\v-gakamb")} | select *

foreach ($svr in $service) {

$stopsvr = $svr.stopservice()

while ($stopsvr.returnvalue -ne "0") {

    Write-Host "$svr.name is stopping"
    Start-Sleep -Seconds 15
}

If ($stopsvr.returnvalue -eq "0") {

    Write-Host "$svr.name -> service stopped successfully"
}

}




$changecred = $service.Change($null, $null, $null, $null, $null, $null, "Redmond\lxpedi", "VFR$%TGBvfr45tgb")

If ($changecred.returnvalue -eq "0") {
    Write-Host "$service -> Credentials change successfully"
}

$startsvr = $service.StartService()

If ($startsvr.returnvalue -eq "0") {
    Write-Host "$service -> service started successfully"
}
