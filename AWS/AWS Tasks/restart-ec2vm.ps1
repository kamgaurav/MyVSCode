param(
  
       [parameter (mandatory=$true)][string] $ComputerName
    )

cls

do {
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

cls

Switch ($Input)

    {
        1{
            $Filter = New-Object Amazon.EC2.Model.Filter
            $Filter.Name = 'tag:Name'
            $Filter.Value = $ComputerName
         
            $Instance = Get-EC2Instance -Filter $Filter | Start-EC2Instance
            $InstanceId = $Instance.InstanceId
            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
            Write-Host "EC2 Instance $ComputerName is starting."
            While ( $InstanceState.Name -ne 'running') 
                {
                    $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
                    Start-Sleep -Seconds 10
                    Write-Host "."
                 }
            Write-Host "EC2 Instance $ComputerName is Started."

         }

         2{
            $Filter = New-Object Amazon.EC2.Model.Filter
            $Filter.Name = 'tag:Name'
            $Filter.Value = $ComputerName
         
            $Instance = Get-EC2Instance -Filter $Filter | Stop-EC2Instance
            $InstanceId = $Instance.InstanceId
            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
            Write-Host "EC2 Instance $ComputerName is stopping."
            While ( $InstanceState.Name -ne 'stopped') 
                {
                    $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
                    Start-Sleep -Seconds 10
                    Write-Host "."
                }
            Write-Host "EC2 Instance $ComputerName is Stopped."
         }

         3{
            $Filter = New-Object Amazon.EC2.Model.Filter
            $Filter.Name = 'tag:Name'
            $Filter.Value = $ComputerName
         
            $Instance = Get-EC2Instance -Filter $Filter | Remove-EC2Instance -Force
            $InstanceId = $Instance.InstanceId
            $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
            Write-Host "EC2 Instance $ComputerName is terminating."
            While ( $InstanceState.Name -ne 'terminated') 
                {
                    $InstanceState = (Get-EC2Instance -InstanceId $InstanceId).RunningInstance[0].State
                    Start-Sleep -Seconds 10
                    Write-Host "."
                }
            Write-Host "EC2 Instance $ComputerName is Terminated."


         }
      
    }

} While ($Input -ne '4')
