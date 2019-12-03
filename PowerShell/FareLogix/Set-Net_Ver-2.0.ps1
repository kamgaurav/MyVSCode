function Set-Proxy { 
    [CmdletBinding()]
    [Alias('proxy')]
    [OutputType([string])]
    Param
    (
        # server address
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        $server,
        # port number
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1)]
        $port    
    )
    
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value "$($server):$($port)"
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 1
         
        
}
 

function Remove-Proxy (){    
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value ""
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 0
}


function Get-Proxy (){
    $a = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    $a.ProxyServer
    $a.ProxyEnable
}


While(($Case = Read-Host -Prompt "Set or Remove") -ne "q"){

Switch($Case){
        s { Set-Proxy 172.28.172.20 8080 }
        r { Remove-Proxy }
        g { Get-Proxy }
        q { "End" }
        default { 
        Write-Host ""
        Write-Host -ForegroundColor Red "Invalid entry: Please enter Set(s) or Remove(r) !!!" 
        Write-Host ""
        }
    }
}

Start-Process ms-settings:network-proxy 
Start-Sleep -Milliseconds 100
Stop-Process -Name SystemSettings
