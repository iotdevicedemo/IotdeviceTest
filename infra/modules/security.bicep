@description('Azure region.')
param location string

@description('Key Vault name. Must be globally unique.')
param keyVaultName string

@description('Whether to enable purge protection. Keep true for production.')
param enablePurgeProtection bool = true

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    enablePurgeProtection: enablePurgeProtection
    publicNetworkAccess: 'Disabled'
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
  tags: {
    environment: 'prod'
    workload: 'iot-platform'
    dataClassification: 'internal'
    managedBy: 'bicep'
  }
}

output id string = keyVault.id
output name string = keyVault.name
