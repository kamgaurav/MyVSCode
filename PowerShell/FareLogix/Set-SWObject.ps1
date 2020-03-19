# This script requires below two modules
# C:\Program Files\WindowsPowerShell\Modules\SwisPowerShell
# C:\Users\gkamble\Documents\WindowsPowerShell\Modules\PowerOrion

# Load the content of csv file
$Content = Import-Csv -Path 'C:\sw.csv'

# Get the SolarWinds credentials

$Creds = Get-Credential

# Connect to SolarWinds server
$Swis = Connect-Swis -Credential $Creds -Hostname localhost

$Content | ForEach-Object {
    $IPAdd = $_.Server
    $app = $_.app
    $client = $_.client
    $env = $_.env
    #$node_arrangement = $_.node_arrangement
    #$node_location = $_.node_location

    $Caption = $IPAdd + "-" + $client + "-" + $env + "-" + $app
    
    # Get Node ID
    $Node = Get-OrionNode -SwisConnection $swis -IPAddress $IPAdd
    $NodeID = $Node.NodeID
    $Uri_Cust_Prop = "swis://localhost/Orion/Orion.Nodes/NodeID=$NodeID/CustomProperties"
    $Uri_Prop = "swis://localhost/Orion/Orion.Nodes/NodeID=$NodeID"
    
    
    Set-SwisObject -SwisConnection $swis -Uri $Uri_Cust_Prop -Properties @{ 
        app              = $_.app;
        client           = $_.client;
        env              = $_.env;
        node_arrangement = $_.node_arrangement;
        node_location    = $_.node_location;
    }

    Set-SwisObject -SwisConnection $swis -Uri $Uri_Prop -Properties @{ 
        Caption = $Caption
    } 
}
