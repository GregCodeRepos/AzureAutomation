workflow Shutdown-Start-VMs-By-Resource-Group
{
	Param
    (   
		# Using WebhookData allows us to pass in multiple parameters
        [object] $WebhookData
       
    )
	
	# If the webhookdata is null, that probably means the runbook is being executed somehow other than via a webhook
	if ($WebhookData -ne $null)
	{
		$WebhookName    =   $WebhookData.WebhookName
    	$WebhookHeaders =   $WebhookData.RequestHeader
	    $WebhookBody    =   $WebhookData.RequestBody
		
		# Convert the object FROM Json back to a regular paramter
		$myVars = ConvertFrom-Json -InputObject $WebhookBody;
		
		# recover the paramter values
		$AzureResourceGroup = $myVars.AzureResourceGroup
		$Shutdown = $myVars.Shutdown
        $ClientID = $myVars.UamiClientID

        Write-Output "AzureResourceGroup: $AzureResourceGroup"
        Write-Output "Shutdown: $Shutdown"
	
		if ($AzureResourceGroup -eq $null)
		{
			Throw "Parameter AzureResourceGroup is null"
		}
		
		if ($Shutdown -eq $null)
		{
			$Shutdown = $true
		}
	
        Write-Output "Logging in to Azure..." 
        try
        {
            $connection  = Connect-AzAccount -Identity -AccountId $ClientID
        }
        catch {
            if (!$connection)
            {
                $ErrorMessage = "Client $ClientID not found."
                throw $ErrorMessage
            } else{
                Write-Error -Message $_.Exception
                throw $_.Exception
            }
        }

		if($Shutdown -eq $true){
			Write-Output "Stopping VMs in '$($AzureResourceGroup)' resource group";
		}
		else{
			Write-Output "Starting VMs in '$($AzureResourceGroup)' resource group";
		}
		
		#ARM VMs
		Write-Output "ARM VMs:";
		  
		Get-AzVM -ResourceGroupName $AzureResourceGroup | ForEach-Object {
		
			if($Shutdown -eq $true){
				
					Write-Output "Stopping '$($_.Name)' ...";
					Stop-AzVM -ResourceGroupName $AzureResourceGroup -Name $_.Name -Force;
			}
			else{
				Write-Output "Starting '$($_.Name)' ...";			
				Start-AzVM -ResourceGroupName $AzureResourceGroup -Name $_.Name;			
			}			
		};
		

	}
	else
	{
		Write-Error "Runbook can only be started from a webhook"
	}
}

