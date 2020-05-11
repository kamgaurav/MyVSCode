#Get the server list
$servers = Get-Content -Path C:\Users\gkamble\Documents\serverlist.txt
#Run the commands for each server in the list
$ServiceInfo = @()
$cre = Get-Credential
Foreach ($s in $servers) {

    $ServiceInfo = New-Object PSObject
                     
    $Connection = Test-Connection $s -Count 1 -Quiet -ErrorAction SilentlyContinue
    

    if ($Connection -eq "True")  {
        $CIMSession = New-CimSession -ComputerName $s -Credential $cre -ErrorAction SilentlyContinue
        if ($CIMSession.Protocol -eq "WSMAN") {
        
            $Computer = Get-CimInstance -CimSession $CIMSession -ClassName win32_computersystem
            $SWAgent = Get-CimInstance -CimSession $CIMSession -ClassName Win32_Service -Filter "displayname = 'SolarWinds Agent'"
        
            if ($SWAgent.DisplayName -eq 'SolarWinds Agent') {
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "IPAddress" -Value $s -Force
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Server Name" -Value $Computer.Name -Force
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Service" -Value $SWAgent.DisplayName
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Status" -Value $SWAgent.State -Force
            }
            else {
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "IPAddress" -Value $s -Force
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Server Name" -Value $Computer.Name -Force
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Service" -Value "No SolarWinds Agent" -Force
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Status" -Value "" -Force
            }

        }
        else {
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "IPAddress" -Value $s -Force
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Server Name" -Value "Could Not Connect" -Force
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Service" -Value "" -Force
            Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Status" -Value "" -Force
        }
        #$ServiceInfo | Export-Csv -Path C:\Users\gkamble\Documents\SolarWinds.csv -Append -NoClobber -NoTypeInformation
        #Remove-CimSession -CimSession $CIMSession
            
    }
    else {
        
        Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "IPAddress" -Value $s -Force
        Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Server Name" -Value "Could Not Connect" -Force
        Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Service" -Value "" -Force
        Add-Member -InputObject $ServiceInfo -MemberType NoteProperty -Name "Status" -Value "" -Force

        #$ServiceInfo | Export-Csv -Path C:\Users\gkamble\Documents\SolarWinds.csv -Append -NoClobber -NoTypeInformation
    } 
    $ServiceInfo | Export-Csv -Path C:\Users\gkamble\Documents\SolarWinds.csv -Append -NoClobber -NoTypeInformation
      
}

 
