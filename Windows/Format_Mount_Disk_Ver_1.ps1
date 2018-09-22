<powershell>
Function FormatDisk {

Param (

        [parameter(mandatory=$true)][int]$DiskNumber,
        [parameter(mandatory=$true)][string]$NewLabel
      )

$Disk = Get-Disk -Number $DiskNumber
if ($Disk.OperationalStatus -eq 'Online') {
    #Write-Host "Deleting existing disk $DiskNumber"
    Clear-Disk -RemoveData -Number $DiskNumber -Confirm:$false
    
}
$MountPath = New-Item -Name $NewLabel -Path "C:\" -ItemType Directory -Force
Initialize-Disk -Number $DiskNumber -PartitionStyle GPT -Confirm:$false
$NewPartition = New-Partition -DiskNumber $DiskNumber -UseMaximumSize -AssignDriveLetter
Start-Sleep 5
$NewPartition | Format-Volume -FileSystem NTFS -NewFileSystemLabel $NewLabel -Confirm:$false| Out-Null
Add-PartitionAccessPath -DiskNumber $DiskNumber -PartitionNumber 2 -AccessPath $MountPath 

}


$RawDisk = Get-Disk | Where-Object {$_.Number -ne '0'} | Sort-Object -Property Number

foreach ($Disk in $RawDisk) {

Switch ($Disk.Number)

    {
        1 {
            FormatDisk -DiskNumber $Disk.Number -NewLabel Data1
          }
        
        2 {
            FormatDisk -DiskNumber $Disk.Number -NewLabel Log
          } 

        3 {
            FormatDisk -DiskNumber $Disk.Number -NewLabel Temp
          }

        4 {
            FormatDisk -DiskNumber $Disk.Number -NewLabel Temp1
          }
    }
}
</powershell>
<persist>true</persist>

#User Data Logs

#Ec2HandleUserData: Plugin default state is Disabled so disable the plugin
#2018-09-19T18:48:41.418Z: Ec2HandleUserData: Executing in a new thread
#2018-09-19T18:48:41.418Z: Ec2HandleUserData: Message: Start running user scripts
#2018-09-19T18:48:41.418Z: Ec2HandleUserData: Message: Could not find <runAsLocalSystem> and </runAsLocalSystem>
#2018-09-19T18:48:41.418Z: Ec2HandleUserData: Message: Could not find <powershellArguments> and </powershellArguments>
#2018-09-19T18:48:41.418Z: Waiting for background plugin to complete: Ec2HandleUserData
#2018-09-19T18:48:41.418Z: Ec2HandleUserData: Message: Re-enabled userdata execution
#2018-09-19T18:48:56.777Z: Ec2HandleUserData: Message: Could not find <script> and </script>
#2018-09-19T18:48:56.777Z: Ec2HandleUserData: Message: Executing C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted . 'C:\Program Files\Amazon\Ec2ConfigService\Scripts\UserScript.ps1' from System account
#2018-09-19T18:48:56.777Z: Ec2HandleUserData: Message: Executing User Data with PID: 2776
#2018-09-19T18:49:12.526Z: Ec2HandleUserData: Message: ExitCode of User Data with PID: 2776 is 0
#2018-09-19T18:49:12.526Z: Ec2HandleUserData: Message: The errors from user scripts: 
#2018-09-19T18:49:12.526Z: Ec2HandleUserData: Message: The output from user scripts: 
#2018-09-19T18:49:12.526Z: Background plugin complete: Ec2HandleUserData
#2018-09-19T18:49:12.526Z: After ready plugins complete.
#2018-09-19T18:49:12.564Z: SSM Service is running now