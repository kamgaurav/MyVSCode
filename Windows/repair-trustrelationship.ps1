#help Test-ComputerSecureChannel
#https://4sysops.com/archives/repair-the-domain-trust-relationship-with-test-computersecurechannel/


$testcomputer = Test-ComputerSecureChannel

if ( $testcomputer -ne $true ) {

Test-ComputerSecureChannel -Repair

}

