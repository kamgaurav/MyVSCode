
$server = Get-Content -Path 'D:\servers.txt'

foreach ($computer in $server) {

    $service = Get-WmiObject -Class Win32_Service -ComputerName $computer | Where-Object {($_.StartName -eq "REDMOND\lrbitfs")} | Select-Object PSComputerName, @{N = 'ServiceName'; E = {$_.DisplayName}}, StartName , State, StartMode
    
    $service | Export-Csv -Path "D:\Service_Info.csv" -NoTypeInformation -Append
         
}
