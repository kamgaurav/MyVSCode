
$data = @()
$vpclist = 'vpc-0e89bf06fd5875311', 'vpc-035ee464be8fa1701', 'vpc-894fc6f3'

foreach ($v in $vpclist) {

$vpc = Get-EC2Vpc -VpcId $v

    $data += [pscustomobject] [ordered] @{

        'VPC_ID' = $vpc.vpcid
        'Tags' = $vpc.tag.value
        'VPC_State' = $vpc.state
    }

}

$data | Export-Csv -Path D:\E-Books\AWS\AA.csv

