$ServerName = ([System.Net.Dns]::GetHostByName(($env:computerName))).HostName
$ServerIPAdd = @(@(Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty IPAddress) -like "*.*")[0]

$Data = @()

Get-ChildItem -Path c:\ -Filter tmp* | foreach {
    $Folder = $_.Name
    $Sub_Folders = 'Test\log'
    foreach ($S in $Sub_Folders) {
        if ((Test-Path -Path C:\$Folder\$S\Bi-rpt.xtr) -eq 'True' -and (Get-Item -Path C:\$Folder\$S\Bi-rpt.xtr).Length/1mb -gt 40) {
            $xtr_File = Get-Item -Path C:\$Folder\$S\Bi-rpt.xtr
            $Data += [pscustomobject] [ordered] @{
                'ServerName' = $ServerName
                'ServerIPAdd' = $ServerIPAdd
                'FilePath' = $xtr_File.FullName
                'FileSize' = "$([math]::round(($xtr_File.Length)/1mb, 2))MB"
            }
        }
    }
}

if ($Data.Count -ge 1 ){
    Write-Host "Statistic.FileSize: $($Data.FileSize)"
    Write-Host "Message.FileSize: $($Data.FilePath)" 
}
else {
    Write-Host "Statistic.FileSize: 0"
    Write-Host "Message.FileSize: None"
}

# Alternate Method

function get-file_size {
$Obj = @()

$ServerName = ([System.Net.Dns]::GetHostByName(($env:computerName))).HostName
$ServerIPAdd = @(@(Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty IPAddress) -like "*.*")[0]

$Folder = Get-ChildItem -Path C:\ -Filter flx* -Directory
$Folder | foreach {
    $File = Get-ChildItem -Path $_.FullName -Depth 2 -Filter Bi-rpt.xtr
    if ($File.count -ge 1) {
        $File | foreach {
            $Obj += [pscustomobject] [ordered] @{
                'ServerName' = $ServerName
                'ServerIPAdd' = $ServerIPAdd
                'FilePath' = $_.DirectoryName
                'FileSize' = "$([math]::round(($_.Length)/1mb, 2))MB"
            }
        }
    }
}
$Obj
}

get-file_size
