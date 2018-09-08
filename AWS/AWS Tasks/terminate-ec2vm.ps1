  param(
    
        [parameter (mandatory=$true)][string[]] $computername
    )

    foreach ($c in $computername)

    {
    

    $filter = New-Object Amazon.EC2.Model.Filter
    $filter.Name = 'tag:Name'
    $filter.Value = $c
         
    $reservation = Get-EC2Instance -Filter $filter | select -ExpandProperty instances
         
    $instanceId = $reservation.InstanceId

    Remove-EC2Instance -InstanceId $instanceId -Force
         
    }