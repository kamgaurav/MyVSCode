$service = Get-WmiObject -Class Win32_Service -ComputerName "gauravkam" | Where-Object {($_.StartName -eq "fareast\v-gakamb")}

foreach ($svr in $service) {
      
    $svr | Stop-Service -Force

    Write-Host ""$svr.DisplayName" -> Service is Stopped"
    Write-Host ""

    $stopsvr = Get-Service -Name  $svr.Name

    if ($stopsvr.Status -eq 'Stopped') {
        
        # User name & password change
        $changecred = $svr.Change($null, $null, $null, $null, $null, $null, "fareast\v-gakamb", "Dec1720#")

        if ($changecred.returnvalue -eq "0") {

            Write-Host ""$svr.DisplayName" -> Password is Changed"
            Write-Host ""
        }
    }  

}

foreach ($svr in $service) {
                
        $svr | Start-Service

        $startsvr = Get-Service -Name $svr.Name

        if ($startsvr.Status -eq 'Running') {

            Write-Host ""$svr.DisplayName" -> Service is in Running State"
            Write-Host ""

        }
}
