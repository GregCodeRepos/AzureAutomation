


$uri = ""
$headers = @{"From"="user@contoso.com"}

$myvars  = @(
    @{AzureResourceGroup="automationLab-dJhXZrbf";Shutdown="true";UamiClientID="8b79fee6-828a-4dfe-b730-2d14d288e51b" }
)

$body = ConvertTo-Json -InputObject $myvars 

$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body

Write-Output $response.JobIds 


