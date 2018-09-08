
$reservation = Get-EC2Instance -InstanceId i-05272405aba44ae2f | select *

$reservation.Instances[0].Tag
$reservation.Instances[0].InstanceType
$reservation.Instances[0].InstanceId
$reservation.Instances[0].KeyName
$reservation.Instances[0].Platform
$reservation.Instances[0].PrivateIpAddress
$reservation.Instances[0].PublicIpAddress
$reservation.Instances[0].PrivateDnsName
$reservation.Instances[0].PublicDnsName
$reservation.Instances[0].RootDeviceName
$reservation.Instances[0].RootDeviceType
$reservation.Instances[0].SecurityGroups
$reservation.Instances[0].State
$reservation.Instances[0].SubnetId
$reservation.Instances[0].VpcId
$reservation.Instances[0].BlockDeviceMappings
$reservation.Instances[0].Hypervisor

#get instance in particular availability zone

(Get-EC2Instance -filter @{Name = "availability-zone"; Values = "us-east-1d"}).Instances[0] | fl

(Get-EC2Instance -Filter @{Name="vpc-id";Value="vpc-1a2bc34d"},@{Name="subnet-id";Value="subnet-1a2b3c4d"}).Instances

#get instnace using instance id 

(Get-EC2Instance -InstanceId i-05272405aba44ae2f).Instances[0]

$reservation.instances[0].InstanceId
