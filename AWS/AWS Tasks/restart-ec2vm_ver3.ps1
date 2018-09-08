do {
cls
Write-Host "------------------------------"
Write-Host
Write-Host '       EC2 Actions           '
Write-Host '                             '
Write-Host '       1. Start              '
Write-Host '       2. Stop               '
Write-Host '       3. Terminate          ' 
Write-Host '       4. Exit               '
Write-Host

$Input = Read-Host "Choose EC2 Action"

if ($input -ne 4) {
    $ComputerName = Read-Host "Enter EC2 instance name"
}

else {break}
cls

function InstanceState()
    {

    param(
  
                [parameter (mandatory=$true)][string] $Computer
            )

       $Filter = New-Object Amazon.EC2.Model.Filter
       $Filter.Name = 'tag:Name'
       $Filter.Value = $Computer
    try {
        $InstanceId = (Get-EC2Instance -Filter $Filter ).Instances[0].InstanceId
        $InstanceState = (Get-EC2Instance -Filter $Filter).Instances[0].State

        if ($InstanceState.name -eq 'terminated')
         {
           Write-Host "EC2 Instance $Computer is already terminated." -ForegroundColor Yellow
           Write-Host ""
           continue
          }
        else {return $InstanceId}
        }

    catch {
            Write-Host "Unable to find EC2 Instance: $Computer" -ForegroundColor Red
            Write-Host ""
            continue
          }
    }

Switch ($Input)

    {
        1{
            $InstanceId = InstanceState -Computer $ComputerName
            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).Instances[0].State

            if ($InstanceState.name -eq 'running')
                {
                    Write-Host "EC2 Instance $ComputerName is already started" -ForegroundColor Yellow
                    Write-Host ""
                    break
                }
            else
                {
                    $InstanceState = (Start-EC2Instance -InstanceId $InstanceId).CurrentState
                    Write-Host "EC2 Instance $ComputerName is starting."
                    While ( $InstanceState.Name -ne 'running') 
                        {
                            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
                            Start-Sleep -Seconds 10
                            Write-Host "."
                        }
    
                    Write-Host "EC2 Instance $ComputerName is started." -ForegroundColor Green
                    Write-Host ""
                } 

         }

         2{
            $InstanceId = InstanceState -Computer $ComputerName
            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).Instances[0].State

            if ($InstanceState.name -eq 'stopped')
                {
                    Write-Host "EC2 Instance $ComputerName is already stopped" -ForegroundColor Yellow
                    Write-Host ""
                    break
                }
            else
                {
                    $InstanceState = (Stop-EC2Instance -InstanceId $InstanceId -Force).CurrentState
                    Write-Host "EC2 Instance $ComputerName is stopping."
                    While ( $InstanceState.Name -ne 'stopped') 
                        {
                            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
                            Start-Sleep -Seconds 10
                            Write-Host "."
                        }
                    Write-Host "EC2 Instance $ComputerName is stopped." -ForegroundColor Green
                    Write-Host ""
                } 
         }
         
         3{
            $InstanceId = InstanceState -Computer $ComputerName
            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).Instances[0].State

            if ($InstanceState.name -eq 'terminated')
                {
                    Write-Host "EC2 Instance $ComputerName is already terminated" -ForegroundColor Yellow
                    Write-Host ""
                    break
                }
            else
                {
                    $InstanceState = (Remove-EC2Instance -InstanceId $InstanceId -Force).CurrentState
                    Write-Host "EC2 Instance $ComputerName is terminating."
                    While ( $InstanceState.Name -ne 'terminated') 
                        {
                            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
                            Start-Sleep -Seconds 10
                            Write-Host "."
                        }
                    Write-Host "EC2 Instance $ComputerName is terminated." -ForegroundColor Green
                    Write-Host ""
                }
            }
      }

} While ($Input -ne '4')
