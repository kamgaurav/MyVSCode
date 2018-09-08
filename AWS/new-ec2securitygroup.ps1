# get security groups

Get-EC2SecurityGroup

# create new security group

$groupid = New-EC2SecurityGroup -Region us-east-1 -GroupName 'Web' -Description 'Allows Http/S traffic from the Internet'

# add rules to security group

$ip1 = @{ ipprotocol="tcp"; fromport="22"; toport="22"; ipranges="0.0.0.0/0"}

$ip2 = @{ ipprotocol="tcp"; fromport="3389"; toport="3389"; ipranges="0.0.0.0/0"}

Grant-EC2SecurityGroupIngress -GroupId $groupid -IpPermission @( $ip1, $ip2 )

# remove rules from security group

Revoke-EC2SecurityGroupIngress -GroupId $groupid -IpPermission $ip1

# remove security group

Remove-EC2SecurityGroup -GroupId $groupid -Force