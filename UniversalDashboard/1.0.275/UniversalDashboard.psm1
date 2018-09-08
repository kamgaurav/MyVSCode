if (!$PSVersionTable.PSEdition -or $PSVersionTable.PSEdition -eq "Desktop") {
    Import-Module -Name "$PSScriptRoot/net451/PowerShellProTools.UniversalDashboard.dll" | Out-Null
}
else {
    Import-Module -Name "$PSScriptRoot/netcoreapp2.0/PowerShellProTools.UniversalDashboard.dll" | Out-Null
}

if (-not $IsRunningInUniversalDashboard -and (Test-Path (Join-Path $PSScriptRoot "license.lic"))) {
	Set-UDLicense -License (Get-Content (Join-Path $PSScriptRoot "license.lic"))
}

Import-Module (Join-Path $PSScriptRoot "UniversalDashboardServer.psm1")

function Set-UDBackwardsCompatbility {
	Write-Warning "This cmdlet is a temporary workaround for scripts using the previous cmdlet names and will be removed in future versions."
	New-Alias -Name "New-Row" -Value "New-UDRow"
	New-Alias -Name "New-Chart" -Value "New-UDChart"
	New-Alias -Name "New-Monitor" -Value "New-UDMonitor"
	New-Alias -Name "New-Column" -Value "New-UDColumn"
	New-Alias -Name "Get-Dashboard" -Value "Get-UDDashboard"
	New-Alias -Name "New-Card" -Value "New-UDCard"
	New-Alias -Name "New-Counter" -Value "New-UDCounter"
	New-Alias -Name "New-Dashboard" -Value "New-UDDashboard"
	New-Alias -Name "New-Grid" -Value "New-UDGrid"
	New-Alias -Name "New-Html" -Value "New-UDHtml"
	New-Alias -Name "New-Image" -Value "New-UDImage"
	New-Alias -Name "New-Link" -Value "New-UDLink"
	New-Alias -Name "New-Page" -Value "New-UDPage"
	New-Alias -Name "New-Table" -Value "New-UDTable"
	New-Alias -Name "Start-Dashboard" -Value "Start-UDDashboard"
	New-Alias -Name "Stop-Dashboard" -Value "Stop-UDDashboard"
	New-Alias -Name "Out-ChartData" -Value "Out-UDChartData"
	New-Alias -Name "Out-MonitorData" -Value "Out-UDMonitorData"
	New-Alias -Name "New-ChartDataSet" -Value "New-UDChartDataSet"
	New-Alias -Name "Out-GridData" -Value "Out-UDGridData"
	New-Alias -Name "Out-TableData" -Value "Out-UDTableData"
}

New-Alias -Name "Row" -Value "New-UDRow" -Force
New-Alias -Name "Column" -Value "New-UDColumn" -Force
New-Alias -Name "Chart" -Value "New-UDChart" -Force
New-Alias -Name "Table" -Value "New-UDTable" -Force
New-Alias -Name "Grid" -Value "New-UDGrid" -Force