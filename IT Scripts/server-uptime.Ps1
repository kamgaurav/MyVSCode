# Author : Ritesh Parab
# Descritption : This {Service Report} PS script will check uptime, auto services and pending reboot and export result into HTML file.

cls
$comps = Get-Content 'd:\Monthly Reboot Report\Serverlist.txt'
$total = $null
del 'd:\Monthly Reboot Report\result.html'  -Force -ErrorAction SilentlyContinue
del 'd:\Monthly Reboot Report\result.csv' -Force -ErrorAction SilentlyContinue
#$Now = Get-Date
$html = @'
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<title> DiskSpace Report</title>
<STYLE TYPE="text/css">
<!--
td {
font-family: Tahoma;
font-size: 11px;
border-top: 1px solid #999999;
border-right: 1px solid #999999;
border-bottom: 1px solid #999999;
border-left: 1px solid #999999;
padding-top: 0px;
padding-right: 0px;
padding-bottom: 0px;
padding-left: 0px;
}
body {
margin-left: 5px;
margin-top: 5px;
margin-right: 0px;
margin-bottom: 10px;

table {
border: thin solid #000000;
}
-->
</style>
</head>
<body>
<table width='100%'>
<tr bgcolor='#CCCCCC'>
<td colspan='7' height='25' align='center'><strong><font color="#003399" size="4" face="tahoma">Service Report </font></strong></td>
</tr>
</table>
<table width='100%'><tbody>
	  <tr bgcolor=#CCCCCC>
	  <td width='14%' height='15' align='center'> <strong> <font color="#003399" size="2" face="tahoma" >Server Name</font></strong></td>
	  <td width='23%' height='15' align='center'> <strong> <font color="#003399" size="2" face="tahoma" >Uptime</font></strong></td>
	  <td width='51%'height='15' align='center'> <strong> <font color="#003399" size="2" face="tahoma"  >Auto-Services</font></strong></td>
	  <td width='12%' height='15' align='center'> <strong> <font color="#003399" size="2" face="tahoma" >Pending Reboot</font></strong></td>
	  </tr>" 
</table>
<table width='100%'><tbody>
'@

Function Uptime($comp){
		function WMIDateStringToDate($Bootup) {
		 [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)
		}
		$NameSpace = "Root\CIMV2"
        $wmi = [WMISearcher]""
      	$wmi.options.timeout = '0:0:15' #set timeout to 30 seconds
      	$query = 'Select * from Win32_OperatingSystem'
      	$wmi.scope.path = "\\$comp\$NameSpace"
      
		$wmi.query = $query
	    Try{
		    $wmiresult = $wmi.Get()
		    #$wmiresult
            foreach ($wmioutput in $wmiresult){
               $Bootup = $wmioutput.LastBootUpTime
               $LastBootUpTime = WMIDateStringToDate($Bootup)
			   $now = Get-Date
               $Reporttime = $now - $lastBootUpTime
               $d = $Reporttime.Days
               $h = $Reporttime.Hours
               $m = $Reporttime.Minutes
               $ms= $Reporttime.Milliseconds
               $a = "Up for: {0} days, {1} hours, {2:N0} minutes" -f $d,$h,$m
               return $a 
			}
		}
		Catch [Exception] {
    		$uperr = '<font color="#FF0000"> RPC Issue : </font>'+ $_
			return $uperr 
		}
	}

function Service($comp){
	#region Ignore 	
		$Ignore = @( 
		    'Microsoft .NET Framework NGEN v4.0.30319_X64', 
		    'Microsoft .NET Framework NGEN v4.0.30319_X86', 
		    'Performance Logs and Alerts', 
		    'Shell Hardware Detection', 
		    'Software Protection'; 
		)
	#endregione
	
		try {
			$autoservices = Get-WmiObject -Namespace 'root\cimv2' -Class Win32_Service -ComputerName $comp -ErrorAction Stop | Where {$_.StartMode -eq 'Auto' -and $Ignore -notcontains $_.DisplayName -and $_.State -ne 'Running'} | % {$_.Displayname}  # | FT Displayname -HideTableHeaders | Out-String  -Stream
			if ($autoservices -ne $null){  #Implement $? last error checking pending 
				foreach ($service in $autoservices) {
				$totalfailednew += $service
				$totalfailednew += " ; "
				}
			}
			else{
				$totalfailednew = "OK"
			}
			return $totalfailednew 
		}
		Catch [Exception] {
    		$serviceerr = '<font color="#FF0000"> RPC Issue : </font>'+ $_ 
			return $serviceerr
		}

	}

function PendingReboot ($comp) {
	process {
		try {
			$WMI_OS = ""
		  	$RegCon  = ""
			$WMI_OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $comp -ErrorAction Stop
			if ($?){
	     	try{ 
				$RegCon = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"LocalMachine",$comp) 
			    If ($WMI_OS.BuildNumber -ge 6001){ 
					$RegValueSetupex = ""
					$RegValuePFRO2k8 = ""
					$RegSubKeySM = $RegCon.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\") 
					$RegValueSetupex = $RegSubKeySM.GetValue("SetupExecute",$null) 
					if ($RegValueSetupex){
						$RegValueSetupex = $true
					}
					
					$RegSubKeySM = $RegCon.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\") 
					$RegValuePFRO2k8 = $RegSubKeySM.GetValue("PendingFileRenameOperations",$null) 
					if ($RegValuePFRO2k8 ){
						$RegValuePFRO2k8  = $true
					}
					
					$RegCon.Close()
					
					if ( $RegValueSetupex -eq $true -or $RegValuePFRO2k8 -eq $true){
						return '<font color="#FF0000">'+$true
					}
					else {
						return $false 							
					}
				}
	            else{   
					$RegValuePFRO2k3 = $false;
					$RegCon = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"LocalMachine","$comp") 
					$RegSubKeySM = $RegCon.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\") 
					$RegValuePFRO2k3 = $RegSubKeySM.GetValue("PendingFileRenameOperations",$null) 
					$RegCon.Close()
					If ($RegValuePFRO2k3) { 
						return  '<font color="#FF0000">'+$true; 
					}
					else {
						return $false; 
					} 
				}
			
			}
			catch {
				return '<font color="#FFFF00">'+"Remote Registry Service KO"
			}
			}
			else {
	       		throw $error[0].Exception
	   		}
		}	
		catch {
				return '<font color="#FF0000">'+"RPC Issue" 		
		}
    }
}

$i=0 # for Progress bar
	
foreach($comp in $comps){
	$i++
	$ErrorActionPreference = "SilentlyContinue" 
	Write-Progress   -Activity "Server Health Check v1.0" -Status ("Checking : {0}" -f $comp) -PercentComplete ($i/$comps.count*100) -Id 0 
	$ErrorActionPreference = "Continue"
	#region Var_Nulling :p  
	$autoservices= $null
	$Reporttimestatus  = $null
	$service = $null;
	$services = $null;
	$totalfailednew = $null
	
	#endregion
	$Reporttimestatus = uptime -comp $comp
	$services = Service -comp $comp
	$pd = PendingReboot $comp
	$newobj = $null
	$newobj = new-object psobject
	$newobj | add-member -membertype noteproperty -name "Server" -value $comp 
	$newobj | add-member -membertype noteproperty -name "Uptime" -value $Reporttimestatus #-PassThru 
	$newobj | add-member -membertype noteproperty -name "AutoServices" -value $services 
	$newobj | add-member -membertype noteproperty -name "PendingReboot" -value $pd
	$newobj | ConvertTo-Csv -NoTypeInformation | Out-File "d:\Monthly Reboot Report\result.csv" -Append
	$htmlserver = $newobj.Server
	$htmluptime = $newobj.Uptime
	$htmlautoservices = $newobj.AutoServices
	$htmlpendingreboot =  $newobj.PendingReboot
$current = "
		<tr bgcolor=#CCCCCC>
		<td width='14%' align='center'>$htmlserver</td>
		<td width='23%' align='center'>$htmluptime</td>
		<td width='51%' align='center'>$htmlautoservices</td>
		<td width='12%' align='center'>$htmlpendingreboot</td>
		</tr>
"
 
	  
	$total += $current 
	#$newobj | ConvertTo-html -Fragment 
	#$newobj | ConvertTo-html -Fragment -CssUri d:\Monthly Reboot Report\Style.css | Out-File d:\Monthly Reboot Report\result.html -Append


}

$HTMLEnd = @"
</div>
</body>
</html>
"@

$MainHtml= $html + $total + $HTMLEnd
$MainHtml  | Out-File "d:\Monthly Reboot Report\result.html" 
