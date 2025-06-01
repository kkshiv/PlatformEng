$tagResList = Get-AzResource -TagName <TagName>  -TagValue <TagValue>
 
foreach($tagRes in $tagResList) { 
		if($tagRes.ResourceId -match "Microsoft.Compute")
		{
			$vmInfo = Get-AzVM -ResourceGroupName $tagRes.ResourceId.Split("//")[4] -Name $tagRes.ResourceId.Split("//")[8]
 
				#Set local variables
				$location = $vmInfo.Location
				$resourceGroupName = $vmInfo.ResourceGroupName
                $timestamp = Get-Date -f MM-dd-yyyy_HH_mm_ss
 
                #Snapshot name of OS data disk
                $snapshotName = $vmInfo.Name +'<TagValue>'+ $timestamp
 
				#Create snapshot configuration
                $snapshot =  New-AzSnapshotConfig -SourceUri $vmInfo.StorageProfile.OsDisk.ManagedDisk.Id -Location $location  -CreateOption copy
				#Take snapshot
                New-AzSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName 

				if($vmInfo.StorageProfile.DataDisks.Count -ge 1){
						#Condition with more than one data disks
						for($i=0; $i -le $vmInfo.StorageProfile.DataDisks.Count - 1; $i++){
							#Snapshot name of OS data disk
							$snapshotName = $vmInfo.StorageProfile.DataDisks[$i].Name +'<TagValue>' + $timestamp 
							#Create snapshot configuration
							$snapshot =  New-AzSnapshotConfig -SourceUri $vmInfo.StorageProfile.DataDisks[$i].ManagedDisk.Id -Location $location  -CreateOption copy 
							#Take snapshot
							New-AzSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName 
						}
					}
				else{
						Write-Host $vmInfo.Name + " doesn't have any additional data disk."
				}
		}
		else{
			$tagRes.ResourceId + " is not a compute instance"
		}
}
