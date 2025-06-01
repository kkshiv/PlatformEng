param region string = '<region>'
param name string = '<KeyVaultName>'

resource KeyVault 'Microsoft.KeyVault/vaults@2024-12-01-preview' = {
  location: region
  name: name
  properties: {
    accessPolicies: [
      {
        objectId: '<UserPrincipalID>'  // User 1
        tenantId: '<tenantid>'
        permissions: {
          certificates: [ 'get', 'list', 'all' ]
          keys: [ 'get', 'list', 'unwrapKey', 'all' ]
          secrets: [ 'get', 'list', 'backup', 'all' ]
          storage: [ 'get', 'list' ]
        }
      }
      {
        objectId: '<UserPrincipalID>'  // User 2
        tenantId: '<tenantid>'
        permissions: {
          certificates: [ 'get', 'list', 'import', 'all' ]
          keys: [ 'get', 'list', 'encrypt', 'decrypt', 'all' ]
          secrets: [ 'get', 'list', 'set', 'recover', 'all' ]
          storage: [ 'get', 'list', 'set', 'all' ]
        }
      }
      {
        objectId: '<UserPrincipalID>'  // User 3
        tenantId: '<tenantid>'
        permissions: {
          certificates: [ 'get', 'list', 'update', 'all' ]
          keys: [ 'get', 'list', 'create', 'delete' , 'all']
          secrets: [ 'get', 'list', 'set', 'all' ]
          storage: [ 'get', 'list', 'delete', 'all' ]
        }
      }
    ]
    createMode: 'default'
    enabledForDeployment:true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enablePurgeProtection: false
    enableRbacAuthorization: false
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      /*ipRules: [
        {
          value: 'string'
        }
      ]
      virtualNetworkRules: [
        {
          id: 'string'
          ignoreMissingVnetServiceEndpoint: bool
        }
      ] */
    }
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
    sku: {
      family: 'A'
      name: 'Standard'
    }
    softDeleteRetentionInDays: 14
    tenantId: '<tenantid>'
  }
  tags: {
    Owner: 'DevOps'
    Environment: 'Prod'
  }
}
