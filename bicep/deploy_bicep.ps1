$resourceGroupName = "automationLab-dJhXZrbf"



new-azresourcegroupdeployment -resourcegroupname $resourceGroupName -templatefile .\bicep\main.bicep -mode Incremental -verbose
