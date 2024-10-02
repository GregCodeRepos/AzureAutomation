Get-AzAutomationAccount -Name aamin001 -ResourceGroupName automationLab-dJhXZrbf | Set-AzAutomationAccount -DisableLocalAuth $false


$uri = "https://b4a52e31-ef95-4da8-bde3-1e756824dd1d.webhook.dewc.azure-automation.net/webhooks?token=qG6kIAe4%2f3Ci%2bsdrehaW%2bivy2bqWOfAlWd%2fXZ8nj0rE%3d"

$headers = @{"From"="glewicki@microsoft.com"}

$myvars  = @(
    @{AzureResourceGroup="automationLab-dJhXZrbf";Shutdown="false";UamiClientID="8b79fee6-828a-4dfe-b730-2d14d288e51b" }
)

$body = ConvertTo-Json -InputObject $myvars 

$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body

Write-Output $response.JobIds 


