@description('Azure region.')
param location string

@description('Globally unique IoT Hub name.')
param name string

@description('SKU capacity.')
param capacity int = 1

resource iotHub 'Microsoft.Devices/IotHubs@2023-06-30' = {
  name: name
  location: location
  sku: {
    name: 'S1'
    capacity: capacity
  }
  properties: {
    publicNetworkAccess: 'Disabled'
    minTlsVersion: '1.2'
    features: 'None'
    disableLocalAuth: false
    networkRuleSets: {
      defaultAction: 'Deny'
      ipRules: []
    }
  }
  tags: {
    environment: 'prod'
    workload: 'iot-platform'
    managedBy: 'bicep'
  }
}

output id string = iotHub.id
output name string = iotHub.name
