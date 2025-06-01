$resourceGroup = "<ResourceGroupName>"
$vmName = "<VirtualMachineName>"

# Get VM details
$vm = Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName

$osDiskName = $vm.StorageProfile.OsDisk.Name
$osDisk = Get-AzDisk -ResourceGroupName $resourceGroup -DiskName $osDiskName

# Change SKU
$osDisk.Sku.Name = "StandardSSD_LRS" #Disk type you want to set
Update-AzDisk -ResourceGroupName $resourceGroup -Disk $osDisk -DiskName $osDiskName

$dataDisks = $vm.StorageProfile.DataDisks
foreach ($disk in $dataDisks) {
    $diskObj = Get-AzDisk -ResourceGroupName $resourceGroup -DiskName $disk.Name
    $diskObj.Sku.Name = "StandardSSD_LRS"
    Update-AzDisk -ResourceGroupName $resourceGroup -Disk $diskObj -DiskName $diskObj.Name
}
