Function Initialize-EC2Disk {

    param(
              [parameter (mandatory=$true)][string] $InstanceId
         )

    $commands = @(
        'Get-Disk | Where partitionstyle -eq "raw" | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:$false -force'
        )

    $parameter = @{
          commands = $commands
    }
    $document = 'AWS-RunPowerShellScript'

    $cmd = Send-SSMCommand -DocumentName $document -Parameter $parameter -InstanceId $InstanceId
    Get-SSMCommand -CommandId $cmd.CommandId

}

Initialize-EC2Disk -InstanceId i-0bdd9e206cbb85c4b
