Get-AWSCredentials -ListProfiledetail | select -ExpandProperty ProfileName |
foreach { Remove-AWSCredentialProfile -Force -ProfileName $_}