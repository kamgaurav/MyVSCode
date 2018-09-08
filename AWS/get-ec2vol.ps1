# retrieves all ec2 instances form vpc & subnet

# (Get-EC2Instance -Filter @{Name="vpc-id";Value="vpc-1a2bc34d"},@{Name="subnet-id";Value="subnet-1a2b3c4d"}).Instances



# retrieves volume id from instance id
$oldvolume = (Get-EC2Volume -Filter @{ Name ="attachment.instance-id" ; values = $reservation.instances[0].InstanceId})

# shows volume attachment to ec2 instance
$attachment = $oldvolume.Attachments