# This PowerShell script is intended to be REMOTE executed on Windows Servers by SolarWinds.
# Written by Patrick McGrath

# ------------------------------------------------------------------------------------------------------------------------------
# Variables to be configured
# ------------------------------------------------------------------------------------------------------------------------------
$globalMemoryThresholds = @{
  #  "8805" = "5GB";
}

$clientSpecificMemoryThresholds = @{
  "EKD-8805" = "12GB";
}

# ------------------------------------------------------------------------------------------------------------------------------
# Custom Property Variables
# ------------------------------------------------------------------------------------------------------------------------------
$client = "${Node.Custom.client}"
$app = "${Node.Custom.app}"
$env = "${Node.Custom.env}"

# ------------------------------------------------------------------------------------------------------------------------------
# Service Monitoring
# ------------------------------------------------------------------------------------------------------------------------------
$services = @(Get-WmiObject Win32_Service | Where-Object { $_.Name -like "atlas64*" })
$healthyServices = @()
$serviceMemoryUsage = @()
$highMemoryServices = @()
$hangingServices = @()
$startPendingServices = @()
$stoppedServices = @()
$disabledServices = @()


# Make an HTTP GET request to the port on localhost for each service that is
# either Running or Started to validate that the service is accepting traffic.

# Atlas services only support HTTP POST, and will return an HTTP 500 Status
# Code when making a GET request to the service. This function verifies that
# a 500 is in fact being returned.
function Invoke-ServiceCheck {
  param($Port)

  $url = "http://localhost:$Port"
  $req = [system.Net.WebRequest]::Create($url)
  try {
    $res = $req.GetResponse()
  }
  catch [System.Net.WebException] {
    $res = $_.Exception.Response
  }

  return ([int]$res.StatusCode -eq 500)
}

# Return the processes for the given service
function Get-ProcessesForService {
  param($Service)
  $processIds = $Service.ProcessId
  return (Get-Process -Id $processIds)
}

# Get the memory usage for the given service
function Get-ServiceMemoryUsage {
  param($Service)
  $process = Get-ProcessesForService -Service $Service
  if ($null -ne $process) {
    return $process.WorkingSet64
  }
  else {
    return $null
  }
}

# Get the CPU usage for the given service
function Get-ServiceCPUUsage {
  param($Service)
  $process = Get-ProcessesForService -Service $Service
  if ($null -ne $process) {
    return $process.CPU
  }
  else {
    return $null
  }
}

function Get-ServicePort {
  param($ServiceName)
  $delimitedPairs = $ServiceName.Split("(").Split(")")
  $delimitedPairs = $delimitedPairs.Split("/").Split("\").Split(" ")
  $portEntries = @()
  $portEntries += ($delimitedPairs | % { $_.Trim() }) | Where-Object { $_ -match "^[0-9]{4,5}" }

  if ($null -ne $portEntries -and $portEntries.Count -gt 0) {
    return $portEntries[0]
  }
  else {
    return $null
  }
}

# Loop over each Atlas service and group them into...

# - Healthy Services (Running and passing the HTTP GET OR Running, with no port specified in the service name)
# - Hanging Services (Running and NOT passing the HTTP GET)
# - Start Pending Services (Recently started / recovering from a crash)
# - Disabled Services (Service is Disabled)
# - Stopped Services (Service is stopped or in another unsupported state)
foreach ($service in $services) {
  $servicePort = Get-ServicePort $service.DisplayName
  $memoryUsage = Get-ServiceMemoryUsage -Service $service

  if ($service.State -eq "Running" -or $service.State -eq "Started") {
    if ($null -eq $servicePort -or (Invoke-ServiceCheck -Port $servicePort)) {
      $healthyServices += @{ "service" = $service; "memoryUsage" = $memoryUsage }
    }
    else {
      $hangingServices += @{ "service" = $service; "memoryUsage" = $memoryUsage }
    }
  }
  elseif ($service.State -eq "StartPending") {
    $startPendingServices += @{ "service" = $service; "memoryUsage" = $memoryUsage }
  }
  elseif ($service.StartMode -eq "Disabled") {
    $disabledServices += @{ "service" = $service; "memoryUsage" = $memoryUsage }
  }
  else {
    $stoppedServices += @{ "service" = $service; "memoryUsage" = $memoryUsage }
  }

  # Memory Usage Check
  $threshold = $null
  if ($globalMemoryThresholds.ContainsKey($servicePort)) {
    $threshold = $globalMemoryThresholds[$servicePort]
  }
  if ($clientSpecificMemoryThresholds.ContainsKey("$client-$servicePort")) {
    $threshold = $clientSpecificMemoryThresholds["$client-$servicePort"]
  }
  if ($null -ne $memoryUsage) {
    if ($null -ne $threshold -and $memoryUsage -gt $threshold) {
      $highMemoryServices += @{ "service" = $service; "memoryUsage" = $memoryUsage }
    }
  }
}

function Get-FormattedServiceNames {
  param($Services)

  if ($Services.Count -eq 0) {
    return "None", 0
  }
  Else {
    $formattedServiceNames = (($Services | % { $_.service.DisplayName + " - " + [Int]($_.memoryUsage / 1MB) + " MB" }) -join " | ")
    return $formattedServiceNames, $Services.count
  }
}

# Report on Service Health to SolarWinds
Write-Host "Statistic.TotalServiceCount: $($services.count)"

$serviceOutputList = @(
  @{
    "displayName" = "HealthyServices";
    "variable" = $healthyServices;
  },
  @{
    "displayName" = "HighMemoryServices";
    "variable" = $highMemoryServices;
  },
  @{
    "displayName" = "HangingServices";
    "variable" = $hangingServices;
  },
  @{
    "displayName" = "StartPendingServices";
    "variable" = $startPendingServices;
  },
  @{
    "displayName" = "DisabledServices";
    "variable" = $disabledServices;
  },
  @{
    "displayName" = "StoppedServices";
    "variable" = $stoppedServices;
  }
)

foreach ($serviceGroup in $serviceOutputList) {
  $formattedServiceNames, $serviceCount = Get-FormattedServiceNames -Services $serviceGroup["variable"]
  Write-Host "Statistic.$($serviceGroup["displayName"]): $serviceCount"
  Write-Host "Message.$($serviceGroup["displayName"]): $formattedServiceNames"
}

# $healthyServiceNames, $healthyServiceCount = Get-FormattedServiceNames -Services $healthyServices
# Write-Host "Statistic.HealthyServices: $healthyServiceCount"
# Write-Host "Message.HealthyServices: $healthyServiceNames"

# $highMemoryServiceNames, $highMemoryServiceCount = Get-FormattedServiceNames -Services $highMemoryServices
# Write-Host "Statistic.HighMemoryServices: $highMemoryServiceCount"
# Write-Host "Message.HighMemoryServices: $highMemoryServiceNames"

# $hangingServiceNames, $hangingServiceCount = Get-FormattedServiceNames -Services $hangingServices
# Write-Host "Statistic.HangingServices: $hangingServiceCount"
# Write-Host "Message.HangingServices: $hangingServiceNames"

# $startPendingServiceNames, $startPendingServiceCount = Get-FormattedServiceNames -Services $startPendingServices
# Write-Host "Statistic.StartPendingServices: $startPendingServiceCount"
# Write-Host "Message.StartPendingServices: $startPendingServiceNames"

# $disabledServiceNames, $disabledServiceCount = Get-FormattedServiceNames -Services $disabledServices
# Write-Host "Statistic.DisabledServices: $disabledServiceCount"
# Write-Host "Message.DisabledServices: $disabledServiceNames"

# $stoppedServiceNames, $stoppedServiceCount = Get-FormattedServiceNames -Services $stoppedServices
# Write-Host "Statistic.StoppedServices: $stoppedServiceCount"
# Write-Host "Message.StoppedServices: $stoppedServiceNames"
