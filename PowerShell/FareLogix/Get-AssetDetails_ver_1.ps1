#Get the server list
$servers = Get-Content D:\MyVSCode\PowerShell\FareLogix\Serverlist.txt
#Run the commands for each server in the list
$ComputerInfo = @()
$Logs = @()

Foreach ($s in $servers)

{
            $ErrorActionPreference = “SilentlyContinue”        
            $ComputerInfo = New-Object PSObject
                         
            $Connection = Test-Connection $s -Count 1 -Quiet

            if ($Connection -eq "True"){
        
            $CIMSession = New-CimSession -ComputerName $s -Authentication Negotiate

            $C = Get-CimInstance -CimSession $CIMSession Win32_ComputerSystem 
            $OSInfo = Get-CimInstance -CimSession $CIMSession Win32_OperatingSystem

            $CPUInfo = Get-CimInstance -CimSession $CIMSession -Class Win32_Processor
            $PhysicalMemory = Get-CimInstance -CimSession $CIMSession -Class CIM_PhysicalMemory | Measure-Object -Property capacity -Sum | % { [Math]::Round(($_.sum / 1GB), 2) }
            $LogicalDisks = Get-CimInstance Win32_LogicalDisk -Namespace "root\CIMV2" -CimSession $CIMSession -Filter "DriveType=3"
                       
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "Server Name" -Value $C.Name -Force
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "IPAddress" -Value $s -Force
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "Domain" -Value $C.Domain -Force
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "OS" -Value $OSInfo.Caption -Force
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "OSArchitecture" -Value $OSInfo.OSArchitecture -Force
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "ServicePack" -Value $OSInfo.servicepackmajorversion -Force
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "CPU Name" -Value $CPUInfo[0].Name -Force
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "CPU Count" -Value $CPUInfo.Count -Force
            Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "PhysicalMemory(GB)" -Value $PhysicalMemory -Force
            $LogicalDisks | ForEach-Object { $ComputerInfo | Add-Member -MemberType noteproperty -name Drive$($_.Name -replace ':' , '') -value ([math]::Round(($_.Size) / 1GB , 2)) -Force} 
            
            
            
            $ComputerInfo | Export-Csv -Path D:\MyVSCode\PowerShell\FareLogix\Inverntory.csv -Append -NoClobber -NoTypeInformation
            
    }
    else {
        
        $Logs = New-Object PSObject
        Add-Member -InputObject $Logs -MemberType NoteProperty -Name "Server Name" -Value $s -Force
        $Logs | Export-Csv -Path D:\MyVSCode\PowerShell\FareLogix\Logs.csv -NoTypeInformation -Append -NoClobber
    
    }   
}