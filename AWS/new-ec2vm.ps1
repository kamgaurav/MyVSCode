#Create instance in default vpc & security group

$ami = Get-EC2Image -ImageId 'ami-97785bed'

# Get-EC2Image -Filter @{ Name="platform"; Values="windows" }
# Get-EC2Image -Region us-west-2

$reservation = New-EC2Instance -ImageId $ami[0].ImageId -KeyName 'MyEC2KeyPair1' `
-InstanceType t2.micro -SecurityGroup 'MyWebDMZ' -MinCount 1 -MaxCount 1 


$instanceId = $reservation.Instances[0].InstanceId

Start-Sleep -Seconds 60

$reservation = Get-EC2Instance -InstanceId $instanceId
$volumeId = $reservation.Instances[0].BlockDeviceMappings.ebs.volumeid
$networkInterfaceId = $reservation.Instances[0].NetworkInterfaces[0].NetworkInterfaceId

# add tag to this ec2 instance

$tag = New-Object Amazon.EC2.Model.Tag
$tag.key = 'Name'
$tag.Value = 'svr2'

New-EC2Tag -Resource $instanceId, $volumeId, $networkInterfaceId -Tag $tag


