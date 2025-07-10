// Below 2 line to be used when Vnet is in same RG otherwise proceed when VM and Vnet is in different Resource Group
//id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
param virtualNetworkName string = '<VnetName>'
param location string = '<region>'
param subnetName string = '<subnetname>'
param VirtualMachineName string = '<VmName>'
param VirtualMachineSize string = '<VM SKU>'
param VirtualMachineSku string = '2022-datacenter-azure-edition'
param DiagnosticsStorageAccountName string = '<Existing Storage Account Name>'
param EnableAcceleratedNetworking bool =  false
@secure()
param AdminUsername string
@secure()
param AdminPassword string


var imageref = {
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku:  VirtualMachineSku
    version: 'latest'
}

var tag = { 
     CostCode: 'xxxxx'
    'Application Owner': 'SQL Team'
    'Technical Owner': 'Apps Team'
 }


 resource networkInterface 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: '${VirtualMachineName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'  
        properties: {           
          subnet: {
         
           id: resourceId(('<RG Name>'), 'Microsoft.Network/virtualNetworks/subnets', (virtualNetworkName), (subnetName))
            name: subnetName          
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    enableAcceleratedNetworking: EnableAcceleratedNetworking
  }
  tags: tag
}


resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: VirtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: VirtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Delete'
      }
    
      imageReference: imageref
      
      dataDisks: [
        {
          createOption: 'Empty'
          name: '${VirtualMachineName}_datadisk_1'
          lun: 0
          diskSizeGB:  512
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }              
      ]  
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    osProfile: {
      computerName: VirtualMachineName
      adminUsername: AdminUsername
      adminPassword: AdminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: false
        provisionVMAgent: true
        patchSettings: {
          enableHotpatching: false
          patchMode: 'Manual'
        }
      }
    }
    diagnosticsProfile: {

      bootDiagnostics: {
        enabled: true
      
      storageUri: 'https://${DiagnosticsStorageAccountName}.blob.core.windows.net/'      
      }
    }
  }
  tags: tag
}

