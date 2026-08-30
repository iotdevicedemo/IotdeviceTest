targetScope = 'resourceGroup'

@description('Azure region for the deployment.')
param location string = resourceGroup().location

@description('Environment name.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environment string = 'dev'

@description('Short workload name used in resource naming.')
param workloadName string = 'iotdemo'

@description('Globally unique IoT Hub name.')
param iotHubName string

resource iotHub 'Microsoft.Devices/IotHubs@2023-06-30' = {
  name: iotHubName
  location: location
  sku: {
    name: 'S1'
    capacity: 1
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    features: 'None'
    minTlsVersion: '1.2'
  }
  tags: {
    workload: workloadName
    environment: environment
    managedBy: 'bicep'
  }
}

output iotHubName string = iotHub.name
output iotHubResourceId string = iotHub.id
