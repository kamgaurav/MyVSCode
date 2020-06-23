


function Connect-VPN {

    #$ErrorActionPreference = “SilentlyContinue”

    cd 'C:\Program Files (x86)\Common Files\Pulse Secure\Integration'

    .\pulselauncher.exe -u gkamble -p Jne@2020# -url access.farelogix.com/corporate -r users
    
}

function Disconnect-VPN {
    
    #$ErrorActionPreference = “SilentlyContinue”

    cd 'C:\Program Files (x86)\Common Files\Pulse Secure\Integration'

    .\pulselauncher.exe -signout -url access.farelogix.com/corporate -r users


}

While(($Case = Read-Host -Prompt "Connect VPN or Disconnect VPN") -ne "q"){

Switch($Case){
        c { Connect-VPN }
        d { Disconnect-VPN }
        q { "End" }
        default { 
        Write-Host ""
        Write-Host -ForegroundColor Red "Invalid entry: Please enter Connect(c) or disconnect(d) !!!" 
        Write-Host ""
        }
    }
}
