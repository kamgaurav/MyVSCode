
#$svr = Get-Service -DisplayName 'VMware NAT Service' | Select-Object -ExpandProperty name
#$service = gwmi win32_service -computername Test-PC -filter "name= '$svr'"
#$service.Change($null,$null,$null,$null,$null,$null,"test-pc\admin","Test@1234")

$svr = Get-WmiObject -Class Win32_Service | Where-Object {($_.StartName -eq ".\admin")}
$stopsvr = $svr.StopService()
If ($stopsvr.returnvalue -eq "0")

{
    Write-Host "$svr -> service stopped successfully"
}

$changecred = $svr.Change($null,$null,$null,$null,$null,$null,"test-pc\administrator","Temp@1234")

If ($changecred.returnvalue -eq "0")

{
    Write-Host "$svr -> Credentials change successfully"
}

$startsvr = $svr.StartService()

If ($startsvr.returnvalue -eq "0")

{
    Write-Host "$svr -> service started successfully"
}
