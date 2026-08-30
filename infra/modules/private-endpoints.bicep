@description('Azure region.')
param location string

@description('Private endpoint subnet resource ID.')
param privateEndpointSubnetId string

@description('IoT Hub resource ID.')
param iotHubResourceId string

@description('Storage account resource ID.')
param storageResourceId string

@description('Key Vault resource ID.')
param keyVaultResourceId string

resource iotPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: 'pe-iothub-prod-eus-01'
  location: location
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'iot-hub-connection'
        properties: {
          privateLinkServiceId: iotHubResourceId
          groupIds: [
            'iotHub'
          ]
        }
      }
    ]
  }
}

resource storagePrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: 'pe-storage-prod-eus-01'
  location: location
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'storage-connection'
        properties: {
          privateLinkServiceId: storageResourceId
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource keyVaultPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: 'pe-kv-prod-eus-01'
  location: location
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'keyvault-connection'
        properties: {
          privateLinkServiceId: keyVaultResourceId
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}
