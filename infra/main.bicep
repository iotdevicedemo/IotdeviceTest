targetScope = 'resourceGroup'

@description('Azure region for the production deployment.')
param location string = resourceGroup().location

@description('Environment name.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environment string = 'prod'

@description('Application/workload name.')
param workloadName string = 'iot-platform'

@description('Production IoT Hub name. Must be globally unique.')
param iotHubName string

@description('Production data lake storage account name. Must be globally unique and lowercase.')
param storageAccountName string

@description('Function App name. Must be globally unique.')
param functionAppName string

@description('Function App storage account name. Must be globally unique and lowercase.')
param functionStorageName string

@description('Log Analytics workspace name.')
param logAnalyticsName string

@description('Application Insights name.')
param appInsightsName string

@description('Key Vault name. Must be globally unique.')
param keyVaultName string

@description('Production spoke VNet name.')
param vnetName string = 'vnet-iot-prod-eus-01'

@description('Automation Account name.')
param automationAccountName string = 'automation-iot-eus-01'

@description('Recovery Services Vault name.')
param recoveryVaultName string = 'backup-iot-prod-eus-01'

module network './modules/network.bicep' = {
  name: 'network-prod'
  params: {
    location: location
    vnetName: vnetName
  }
}

module monitoring './modules/monitoring.bicep' = {
  name: 'monitoring-prod'
  params: {
    location: location
    logAnalyticsName: logAnalyticsName
    appInsightsName: appInsightsName
  }
}

module security './modules/security.bicep' = {
  name: 'security-prod'
  params: {
    location: location
    keyVaultName: keyVaultName
  }
}

module iotHub './modules/iothub.bicep' = {
  name: 'iot-hub-prod'
  params: {
    location: location
    name: iotHubName
  }
}

module storage './modules/storage.bicep' = {
  name: 'storage-prod'
  params: {
    location: location
    name: storageAccountName
  }
}

module functions './modules/functions.bicep' = {
  name: 'functions-prod'
  params: {
    location: location
    functionAppName: functionAppName
    functionStorageName: functionStorageName
    appInsightsResourceId: monitoring.outputs.appInsightsId
    appInsightsConnectionString: monitoring.outputs.appInsightsConnectionString
    appSubnetId: network.outputs.appSubnetId
  }
}

module privateEndpoints './modules/private-endpoints.bicep' = {
  name: 'private-endpoints-prod'
  params: {
    location: location
    privateEndpointSubnetId: network.outputs.privateEndpointSubnetId
    iotHubResourceId: iotHub.outputs.id
    storageResourceId: storage.outputs.id
    keyVaultResourceId: security.outputs.id
  }
}

module sharedServices './modules/shared-services.bicep' = {
  name: 'shared-services-prod'
  params: {
    location: location
    automationAccountName: automationAccountName
    recoveryVaultName: recoveryVaultName
  }
}

output iotHubResourceId string = iotHub.outputs.id
output storageResourceId string = storage.outputs.id
output functionAppResourceId string = functions.outputs.id
output keyVaultResourceId string = security.outputs.id
output logAnalyticsResourceId string = monitoring.outputs.logAnalyticsId
output recoveryVaultResourceId string = sharedServices.outputs.recoveryVaultId
