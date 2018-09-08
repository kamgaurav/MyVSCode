# create new vpc

$vpc = New-EC2Vpc -CidrBlock '192.168.0.0/16'
$vpc.VpcId

# create 2 new subnet 192.168.1.0/24 & 192.168.2.0/24

$subnet1 = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock '192.168.1.0/24' -AvailabilityZone 'us-east-1a'
$subnet2 = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock '192.168.2.0/24' -AvailabilityZone 'us-east-1a'

# create new internet gateway

$ig = New-EC2InternetGateway
Add-EC2InternetGateway -InternetGatewayId $ig.InternetGatewayId -VpcId $vpc.VpcId


# create filter on vpc parameter to get routes

$vpcfilter = New-Object Amazon.EC2.Model.Filter
$vpcfilter.Name = 'vpc-id'
$vpcfilter.Value = $vpc.VpcId

(Get-EC2RouteTable -Filter $vpcfilter).Routes | ft


# find main route table

$isdefaultfilter = New-Object Amazon.EC2.Model.Filter 
$isdefaultfilter.Name = 'association.main'
$isdefaultfilter.Value = 'true'
$defaultroutetable = Get-EC2RouteTable -Filter $vpcfilter, $isdefaultfilter
$defaultroutetable.Routes | ft

# create new route in default route table

New-EC2Route -RouteTableId $defaultroutetable.RouteTableId -DestinationCidrBlock '0.0.0.0/0' -GatewayId $ig.InternetGatewayId

# create new route table

$routetable = New-EC2RouteTable -VpcId $vpc.VpcId

# associate route table with subnet 192.168.2.0/24

Register-EC2RouteTable -RouteTableId $routetable.RouteTableId -SubnetId $subnet2.SubnetId


# make second route table as main route table

$vpcfilter = New-Object Amazon.EC2.Model.Filter
$vpcfilter.Name = 'vpc-id'
$vpcfilter.Value = $vpc.VpcId

$isdefaultfilter = New-Object Amazon.EC2.Model.Filter
$isdefaultfilter.Name = 'association.main'
$isdefaultfilter.Value = 'true'

$mainroutetable = Get-EC2RouteTable -Filter $vpcfilter, $isdefaultfilter

# an association maps a route table to a subnet, but the main association is special, in that the subnet is blank. 

# Means no routes are associated with main route table

$association = $mainroutetable.Associations | where {$_.Main -eq 'true'}
$association

Set-EC2RouteTableAssociation -AssociationId $association.RouteTableAssociationId -RouteTableId $routetable.RouteTableId

$publicsubnet = Get-EC2Subnet -Filter @{Name = "vpc-id" ; value = $vpc.VpcId} | Where-Object {$_.CidrBlock -eq '192.168.1.0/24'}
$privatesubnet = Get-EC2Subnet -Filter @{Name = "vpc-id" ; value = $vpc.VpcId} | Where-Object {$_.CidrBlock -eq '192.168.2.0/24'}

$netacl = Get-EC2NetworkAcl -Filter @{Name = "vpc-id" ; value = $vpc.VpcId}

Remove-EC2NetworkAclEntry -NetworkAclId $netacl.NetworkAclId -RuleNumber 100 -Egress $true -Force
Remove-EC2NetworkAclEntry -NetworkAclId $netacl.NetworkAclId -RuleNumber 100 -Egress $false -Force

New-EC2NetworkAclEntry -NetworkAclId $netacl.NetworkAclId -RuleNumber 100 -CidrBlock '0.0.0.0/0' -Egress $false `
-PortRange_From 80 -PortRange_To 80 -Protocol 6 -RuleAction allow

New-EC2NetworkAclEntry -NetworkAclId $netacl.NetworkAclId -RuleNumber 100 -CidrBlock '0.0.0.0/0' -Egress $true `
-PortRange_From 32768 -PortRange_To 61000 -Protocol 6 -RuleAction allow 

New-EC2NetworkAclEntry -NetworkAclId $netacl.NetworkAclId -RuleNumber 200 -CidrBlock '192.168.2.0/24' -Egress $true `
-PortRange_From 22 -PortRange_To 22 -Protocol 6 -RuleAction allow

New-EC2NetworkAclEntry -NetworkAclId $netacl.NetworkAclId -RuleNumber 200 -CidrBlock '192.168.2.0/24' -Egress $false `
-PortRange_From 32768 -PortRange_To 61000 -Protocol 6 -RuleAction allow

New-EC2NetworkAclEntry -NetworkAclId $netacl.NetworkAclId -RuleNumber 50 -CidrBlock '192.168.0.0/16' -Egress $false `
-PortRange_From 80 -PortRange_To 80 -Protocol 6 -RuleAction deny

New-EC2NetworkAclEntry -NetworkAclId $netacl.NetworkAclId -RuleNumber 50 -CidrBlock '192.168.0.0/16' -Egress $true `
-PortRange_From 80 -PortRange_To 80 -Protocol 6 -RuleAction deny

$acl = New-EC2NetworkAcl -VpcId $vpc.VpcId
$acl.Entries | ft

New-EC2NetworkAclEntry -NetworkAclId $acl.NetworkAclId -RuleNumber 100 -CidrBlock '0.0.0.0/0' -Egress $true -Protocol '-1' -RuleAction allow

New-EC2NetworkAclEntry -NetworkAclId $acl.NetworkAclId -RuleNumber 100 -CidrBlock '0.0.0.0/0' -Egress $false -Protocol '-1' -RuleAction allow

$oldacl = Get-EC2NetworkAcl -Filter @{name = "association.subnet-id" ; value = $privatesubnet.subnetid}

$oldassociation = $oldacl.Associations | where {$_.SubnetId -eq $privatesubnet.subnetid}

Set-EC2NetworkAclAssociation -AssociationId $oldassociation.NetworkAclAssociationId -NetworkAclId $acl.NetworkAclId



$MaxAcl = ((Get-EC2NetworkAcl -NetworkAclId $acl.NetworkAclId).Entries | `
Where-Object {$_.Egress -and $_.RuleNumber -lt 32767 } | Measure-Object RuleNumber -Maximum).Maximum
$NextAcl = $MaxAcl + 100