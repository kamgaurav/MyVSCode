$TestCon = Test-Connection -ComputerName app1119 -Count 1 -Quiet
if ($TestCon -eq 'True')
{
    $TestPort = Test-NetConnection -ComputerName app1119 -Port 8804
    #$TestPort.RemoteAddress
    #$TestPort.RemotePort
    if ($TestPort.TcpTestSucceeded -eq 'True')
    {
        try
        {
            $response = Invoke-WebRequest -Uri "http://192.168.10.13:8804" -ErrorAction SilentlyContinue
            $res = Invoke-RestMethod -Uri "http://192.168.10.13:8804"
            # This will only execute if the Invoke-WebRequest is successful.
            $StatusCode = $Response.StatusCode
        }

        catch
        {
            $StatusCode = $_.Exception.Response.StatusCode.value__
        }
            $StatusCode
        
    } 
    
}