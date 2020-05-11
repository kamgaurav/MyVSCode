$folders = Get-ChildItem -Path c:\ -Filter flx*

$folders.Name[0]

Test-Path -Path C:\$($folders.Name[0])\Bi-rpt.xtr

Test-Path -Path C:\$($folders.Name[1])\Bi-rpt.xtr

$file = Get-ChildItem -Path "C:\$($folders.Name[0])\Bi-rpt.xtr"

$file| select *

Get-NetIPAddress

Get-CimInstance -ClassName win32_networkadapterconfiguration | Where {$_.DNSDomain -eq 'cybage.com'} | Select-Object -ExpandProperty IPAddress 

Get-CimInstance -ClassName Win32_OperatingSystem | select *

Get-CimInstance -ClassName Win32_ComputerSystem 

$folders = Get-ChildItem -Path c:\ -Filter flx*

$obj = @()

for ($i=0; $i -lt 2; $i++) {

$sub_folders = 'DCServer\log', 'DMServer\log', 'PricingEngine\log'

foreach ($s in $sub_folders) {

    if ((Test-Path -Path C:\$($folders.Name[$i])\$s\Bi-rpt.xtr) -eq 'True' -and (Get-Item -Path C:\$($folders.Name[$i])\$s\Bi-rpt.xtr).Length/1mb -gt 40) {
        
        $xtr_file = Get-Item -Path C:\$($folders.Name[$i])\$s\Bi-rpt.xtr

        $obj += [pscustomobject] [ordered] @{

            
            $xtr_file.FullName
            [math]::round(($xtr_file.Length)/1mb, 2)

        }
    }
}

}

$xtr_file.FullName
[math]::round(($xtr_file.Length)/1mb, 2)

