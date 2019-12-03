param([switch]$Elevated)

function Set-Env (){

    $AWS_ACCESS_KEY_ID = Read-Host -Prompt "Enter AWS Access Key ID"
    $AWS_SECRET_ACCESS_KEY = Read-Host -Prompt "Enter AWS Secret Access Key"

    #Set-Item -Path Env:AWS_ACCESS_KEY_ID -Value ($Env:AWS_ACCESS_KEY_ID + "$AWS_ACCESS_KEY_ID")
    #Set-Item -Path Env:AWS_SECRET_ACCESS_KEY -Value ($Env:AWS_SECRET_ACCESS_KEY + "$AWS_SECRET_ACCESS_KEY")

    [Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID","$AWS_ACCESS_KEY_ID","Machine")
    [Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY","$AWS_SECRET_ACCESS_KEY","Machine")
    Write-Host ""
    Write-Host -ForegroundColor Yellow "Environment Variables Added !!"
    Write-Host ""

}

function Remove-Env (){
    #Remove-Item -Path Env:AWS_ACCESS_KEY_ID
    #Remove-Item -Path Env:AWS_SECRET_ACCESS_KEY

    [Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID","","Machine")
    [Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY","","Machine")
    Write-Host ""
    Write-Host -ForegroundColor Yellow "Environment Variables Removed !!"
    Write-Host ""
}

function Get-Env (){
    #Get-ChildItem Env:* | Where-Object {$_.Name -eq 'AWS_ACCESS_KEY_ID'}
    #Get-ChildItem Env:* | Where-Object {$_.Name -eq 'AWS_SECRET_ACCESS_KEY'}

    [Environment]::GetEnvironmentVariable("AWS_ACCESS_KEY_ID", "machine")
    [Environment]::GetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", "machine")
}

While(($Case = Read-Host -Prompt "Set or Remove Environment Variables") -ne "q"){

Switch($Case){
        s { Set-Env }
        r { Remove-Env }
        g { Get-Env }
        q { "End" }
        default { 
        Write-Host ""
        Write-Host -ForegroundColor Red "Invalid entry: Please enter Set(s) or Remove(r) !!!" 
        Write-Host ""
        }
    }
}

