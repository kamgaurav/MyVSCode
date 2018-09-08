#add volume to ec2 instance with .Net objects

$vol = New-Object Amazon.EC2.Model.EbsBlockDevice
$vol.DeleteOnTermination = $False
$vol.VolumeSize = 2
$vol.VolumeType = 'gp2'

$map = New-Object Amazon.EC2.Model.BlockDeviceMapping
$map.DeviceName = 'xvdf'
$map.Ebs = $vol

$ami = 'ami-55ef662f'

$vm = New-EC2Instance -ImageId $ami -KeyName 'MyEC2KeyPair' -InstanceType t2.micro -MinCount 1 -MaxCount 1 -BlockDeviceMapping $map

$instance = $vm.RunningInstance[0]
$instance = $vm.Instances

#add volume with new-ec2volume command

$vol2  = New-EC2Volume -Size 2 -VolumeType standard -AvailabilityZone us-east-1a
Add-EC2Volume -VolumeId $vol2.VolumeId -InstanceId i-0fd348981fc70e19c -Device 'xvdg'


#filter based on instance id

$filter =  New-Object Amazon.EC2.Model.Filter
$filter.Name = 'attachment.instance-id'
$filter.Value = 'i-08e49c70a98526dfc'
Get-EC2Volume -Filter $filter

#shutdown & terminate ec2 instance

Remove-EC2Instance -InstanceId i-08e49c70a98526dfc -Force