#Chapter 3 : Basic Instance Management


cls

Get-EC2Image 

$ami = "ami-55ef662f"
$keyname = 'E:\Server Books\Cloud Computing\AWS\AWS Key\MyEC2KeyPair1.pem'
New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType 't2.micro' -MinCount 1 -MaxCount 1 

Stop-EC2Instance -InstanceId 'i-0391e578eb208afae' -Terminate -Force
Remove-EC2Instance -InstanceId 'i-08945f18e0cd4825a' -Force

Get-EC2Instance | ft
Get-EC2Instance -InstanceId 'i-08945f18e0cd4825a'

$userdata = @'
This is test!!!
<TestValue>42</TestValue>
'@
$userdata = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($UserData))
$ami = Get-EC2ImageByName -Name WINDOWS_2012R2_BASE
$reservation = New-EC2Instance -ImageId $ami[0].ImageId -KeyName 'MyEC2KeyPair1' -InstanceType 't2.micro' -MinCount 1 -MaxCount 1 -UserData $userdata

#Retrieve password
Get-EC2PasswordData -InstanceId 'i-0391e578eb208afae' –PemFile 'E:\Server Books\Cloud Computing\AWS\AWS Key\MyEC2KeyPair1.pem'

Invoke-RestMethod 'http://34.239.134.222/latest/user-data'

#get metadata about ec2 instance
(Get-EC2Instance -InstanceId i-0391e578eb208afae).RunningInstance[0] | fl
$reservation.RunningInstance[0] | fl

$r = Get-EC2Instance -InstanceId i-0391e578eb208afae
$instance = $r.RunningInstance[0]
$instance.Tag

#create tag
$instanceid = $reservation.RunningInstance[0].InstanceId
$tag = New-Object Amazon.EC2.Model.Tag
$tag.Key = 'Name'
$tag.Value = 'MyServer'
New-EC2Tag -Resource $instanceid -Tag $tag


#tag other resources

$VolumeId = $reservation.RunningInstance[0].BlockDeviceMappings[0].
$NetworkInterfaceId = $reservation.RunningInstance[0].NetworkInterfaces[0].NetworkInterfaceId
New-EC2Tag -ResourceId $instanceid, $VolumeId, $NetworkInterfaceId -Tag $tag

# use filter to get resources
$filter = New-Object Amazon.EC2.Model.Filter
$filter.name = 'tag:Name'
$filter.value = 'Server1'
Get-EC2Instance -Filter $filter