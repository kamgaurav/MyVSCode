$serverList = ".\Servers.txt"
$outputCSV = ".\ServerInventory.csv"
$credential = get-credential 
 
$scriptpath = $MyInvocation.MyCommand.Path
#$dir = Split-Path $scriptpath
pushd $dir
 
[System.Collections.ArrayList]$sysCollection = New-Object System.Collections.ArrayList($null)
  
foreach ($server in (Get-Content $serverList))
{
    "Collecting information from $server"
    $totCores=0
  
    try
    {
        [wmi]$sysInfo = get-wmiobject Win32_ComputerSystem -Namespace "root\CIMV2" -ComputerName $server -Credential $credential -ErrorAction Stop
        [wmi]$bios = Get-WmiObject Win32_BIOS -Namespace "root\CIMV2" -computername $server -Credential $credential
        [wmi]$os = Get-WmiObject Win32_OperatingSystem -Namespace "root\CIMV2" -Computername $server -Credential $credential
        #[array]$disks = Get-WmiObject Win32_LogicalDisk -Namespace "root\CIMV2" -Filter DriveType=3 -Computername $server
        [array]$disks = Get-WmiObject Win32_LogicalDisk -Namespace "root\CIMV2" -Computername $server -Credential $credential
        [array]$procs = Get-WmiObject Win32_Processor -Namespace "root\CIMV2" -Computername $server -Credential $credential
        [array]$mem = Get-WmiObject Win32_PhysicalMemory -Namespace "root\CIMV2" -ComputerName $server -Credential $credential
        [array]$nic = Get-WmiObject Win32_NetworkAdapterConfiguration -Namespace "root\CIMV2" -ComputerName $server -Credential $credential | where{$_.IPEnabled -eq "True"}
  
        $si = @{
            Server          = [string]$server
            OSName          = [string]$os.Name.Substring(0,$os.Name.IndexOf("|") -1)
            Manufacturer    = [string]$sysInfo.Manufacturer
            Model           = [string]$sysInfo.Model
            TotMem          = "$([string]([System.Math]::Round($sysInfo.TotalPhysicalMemory/1gb,2))) GB"
            Arch            = [string]$os.OSArchitecture
            Processors      = [string]@($procs).count
            Cores           = [string]$procs[0].NumberOfCores
             
        }
         
        $disks | foreach-object {$si."Drive$($_.Name -replace ':', '')"="$([string]([System.Math]::Round($_.Size/1gb,2))) GB"}
        $disks | foreach-object {$si."FreeSpace$($_.Name -replace ':', '')"="$([string]([System.Math]::Round($_.FreeSpace/1gb,2))) GB"}
    }
    catch [Exception]
    {
        "Error communicating with $server, skipping to next"
        $si = @{
            Server          = [string]$server
            ErrorMessage    = [string]$_.Exception.Message
            ErrorItem       = [string]$_.Exception.ItemName
        }
        Continue
    }
    finally
    {
       [void]$sysCollection.Add((New-Object PSObject -Property $si))   
    }
}
  
$sysCollection `
    | select-object Server,OSName,TotMem,Arch,Processors,Cores,Manufacturer,Model,DriveC,FreeSpaceC,DriveD,FreeSpaceD,DriveE,FreeSpaceE, DriveF,FreeSpaceF, DriveG,FreeSpaceG,
    DriveH,FreeSpaceH, DriveI,FreeSpaceI, DriveJ,FreeSpaceJ, DriveK,FreeSpaceK, DriveL,FreeSpaceL, DriveM,FreeSpaceM, DriveN,FreeSpaceN, 
    DriveO,FreeSpaceO, DriveP,FreeSpaceP, DriveQ,FreeSpaceQ, DriveR,FreeSpaceR, DriveS,FreeSpaceS, DriveT,FreeSpaceT, DriveU,FreeSpaceU, DriveV,FreeSpaceV,
    DriveW,FreeSpaceW, DriveX,FreeSpaceX, DriveY,FreeSpaceY, DriveZ,FreeSpaceZ `
    | sort -Property Server `
    | Export-CSV -path $outputCSV -NoTypeInformation

    