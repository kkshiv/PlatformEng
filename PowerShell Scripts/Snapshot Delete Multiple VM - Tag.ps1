# Set the string to filter snapshots
$filterString = "<tagValue>"

# Get all resource groups in the subscription
$resourceGroups = Get-AzResourceGroup

# Loop through each resource group
foreach ($resourceGroup in $resourceGroups) {
    $resourceGroupName = $resourceGroup.ResourceGroupName

    Write-Host "Checking Resource Group:" $resourceGroupName

    # Get all snapshots in the current resource group
    $snapshots = Get-AzSnapshot -ResourceGroupName $resourceGroupName

    # Filter snapshots by name containing the filter string
    $filteredSnapshots = $snapshots | Where-Object { $_.Name -like "*$filterString*" }

    # Loop through filtered snapshots and delete them
    foreach ($snapshot in $filteredSnapshots) {
        Write-Host "Removing snapshot:" $snapshot.Name "in Resource Group:" $resourceGroupName
        Remove-AzSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshot.Name -Force
    }
}