
try {
    Invoke-RestMethod -Uri "http://localhost:$Port"
} catch {
    # Dig into the exception to get the Response details.
    # Note that value__ is not a typo.
    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
} 

try {
    Invoke-WebRequest -Uri "http://localhost:$Port"
} catch {
    # Dig into the exception to get the Response details.
    # Note that value__ is not a typo.
    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
} 
