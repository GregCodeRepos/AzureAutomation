Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"
$random = -join ((65..90) + (97..122) | Get-Random -Count 8 | % {[char]$_})
$resourceGroup = "automationLab-$random"
$location = "germanywestcentral"
$vmName = "VM1"
$userName='AdminUser'
$password='P@55word1234'| ConvertTo-SecureString -Force -AsPlainText
$cred=New-Object PSCredential($UserName,$Password)
$resourceGroupObject = New-AzResourceGroup -Name $resourceGroup -Location $location -Force
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name frontEnd -AddressPrefix 10.5.0.0/28
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
-Name AutomvNET1 -AddressPrefix 10.5.0.0/24 -Subnet $subnetConfig -Force
$pip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
-Name "autovm1pip$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp `
-Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
-DestinationPortRange 3389 -Access Allow
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
-Name autoVm1NetworkSecurityGroup -SecurityRules $nsgRuleRDP -Force
$nic = New-AzNetworkInterface -Name AutomVM1Nic -ResourceGroupName $resourceGroup -Location $location `
-SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id -Force
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_D2s_v3 | `
Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version latest | `
Add-AzVMNetworkInterface -Id $nic.Id
$vmConfig | Set-AzVMBootDiagnostic -Disable
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig

# https://e7baddfc-4c9b-44bc-9ff8-d2301aa6931c.webhook.dewc.azure-automation.net/webhooks?token=2w3Svp2WiWjG4bb7Xe1QAwzCDGtYTrRYuoCie6yJ11o%3d