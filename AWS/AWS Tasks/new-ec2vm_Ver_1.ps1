param (
        [parameter(mandatory=$true)][string] $ImageName,
        [parameter(mandatory=$true)][string] $InstanceType,
        [parameter(mandatory=$true)][string] $InstanceName,
        [int]$retryCount = 30
       )
$Ami = Get-EC2ImageByName -Names "$ImageName"

# Create EC2 instance & reservation object
$Reservation = New-EC2Instance -ImageId $Ami.ImageId -KeyName 'MyKeyPair' -InstanceType $InstanceType -MinCount 1 -MaxCount 1 
$InstanceId = $Reservation.Instances[0].InstanceId
$InstanceState = (Get-EC2Instance -InstanceId $instanceId).RunningInstance[0].State

While ( $InstanceState.Name -ne 'running') 

      {
        Start-Sleep -Seconds 15
        $InstanceState = (Get-EC2Instance -InstanceId $instanceId).RunningInstance[0].State
      }

# Refresh reservation object
$Reservation = Get-EC2Instance -InstanceId $InstanceId
$VolumeId = $Reservation.Instances[0].BlockDeviceMappings.ebs.volumeid
$NetworkInterfaceId = $Reservation.Instances[0].NetworkInterfaces[0].NetworkInterfaceId


# Add tags to EC2 instance
$Tag = New-Object Amazon.EC2.Model.Tag
$Tag.key = 'Name'
$Tag.Value = $InstanceName
New-EC2Tag -Resource $InstanceId, $VolumeId, $NetworkInterfaceId -Tag $Tag

# Get password for instance
While ($retryCount -gt 1)
      {
        Try
        {
            $Password = Get-EC2PasswordData -InstanceId $InstanceId -PemFile 'C:\MyKeyPair.pem'
            return $Password
        }
        Catch 
        {
            $retryCount --
            Start-Sleep -Seconds 60
            Write-Host 
        }
      }

