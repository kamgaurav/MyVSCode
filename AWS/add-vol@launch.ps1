# managing volumes at launch

$ami = 'ami-97785bed'

$vol = New-Object Amazon.EC2.Model.EbsBlockDevice
$vol.DeleteOnTermination = $true
$vol.VolumeType = 'gp2'
$vol.VolumeSize = 8

$map = New-Object Amazon.EC2.Model.BlockDeviceMapping
$map.DeviceName = '/dev/xvda'
$map.Ebs = $vol


$vm = New-EC2Instance -ImageId $ami -KeyName 'MyEC2KeyPair' -InstanceType t2.micro -BlockDeviceMapping $map -MinCount 1 -MaxCount 1

$instance = $vm.Instances


