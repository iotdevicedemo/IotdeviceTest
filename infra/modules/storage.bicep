@description('Azure region.')
param location string

@description('Globally unique storage account name. 3-24 lowercase alphanumeric characters.')
param name string

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    publicNetworkAccess: 'Disabled'
    accessTier: 'Hot'
  }
  tags: {
    environment: 'prod'
    workload: 'iot-platform'
    dataClassification: 'internal'
    managedBy: 'bicep'
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  name: 'default'
  parent: storage
}

output id string = storage.id
output name string = storage.name
output blobEndpoint string = storage.properties.primaryEndpoints.blob
