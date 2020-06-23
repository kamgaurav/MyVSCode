$accesskey = 'ASIA3JT4CKIZ6SCXIRXB'
$secretkey = 'qiRTnugGRodmf9Hu9x8PycR3wLzpx0/wtTUCAk9h'
$sessiontoken ='IQoJb3JpZ2luX2VjELn//////////wEaCXVzLWVhc3QtMSJHMEUCIQCF3dQA+uJCtGZr+mrzxTJRyhFsAW5IAfloGOWLpOOIugIgQYgRlU2QiV+dPRJazmIUbpIsHAh0+f5Lpv2ou5S+SPoqkQIIEhABGgw3NzY1NzU1Mzc3MTUiDEfoZN7p/VzpYBxAjiruAUGIn3FoEZbsyzlJUTi8FlXtm+coymBC40jE5MbBxD+FgAOYMiGHxPbPx6NsQyQXKwknesUmpkCy0FXHuLx6EyfbsmbPrmzlGa5Uw3yU42N8OJzLtqpOhEnjGUlpEQc/tvxn0qfxCJPWTZhCCj1nCVCDQBV38LradEstFfilkdp4lan5vOL40aNgyAk087/LvxUkraJXvCOR4KVMk/aTuaIALk3+v3yhbUvCeBuALGeZe51rcjfoTZTTbchonT2UpA/gdvkCilJc5za0meTUjn7OTPxbaLJoPYoW2IeI/lC3KMftpD/VvwLFBhN1Kl0wzuKT9gU66QHh5vRRCJt5xkn85s0R6oOqqslSW7dLhhsIs1u1sEZWVwNLBsdyH/NbY78Bn1gAJI4IX4cKag2rIlNpX9nrz1oZHzXO7O0hKIj0jizlxskcB4iLV1QZ0Ulf6M3tBDKdH/mqHvkSNEPTdZaMDosg7r4+Zr18qAHkKnLw+TQW9gz/fw56Tf2c1KvOidlX6NIWY46COBhIIBCsrrENdBSqo/mIUgDA+Xp0nKDsBKlYXNoECRuaRLIPku2YR76BHk3cW7m0F1HQ+ps4Uy9yXjQBaC07otJwvB4qkhluGEATadeHhBSdIKHU9gkDgg=='

#$region = Read-Host "Enter Region"
#$profile = Read-Host "Enter Profile Name"

$region = 'us-east-1'
$profile = 'dev'

Set-AWSCredentials -AccessKey $accesskey -SecretKey $secretkey -SessionToken $sessiontoken -StoreAs $profile
Set-DefaultAWSRegion -Region $region

Initialize-AWSDefaultConfiguration -ProfileName $profile -Region $region

Get-AWSCredentials -ListProfiledetail

