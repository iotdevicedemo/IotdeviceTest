@description('Azure region.')
param location string

@description('Automation Account name.')
param automationAccountName string

@description('Recovery Services Vault name.')
param recoveryVaultName string

resource automation 'Microsoft.Automation/automationAccounts@2023-11-01' = {
  name: automationAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: true
  }
  tags: {
    environment: 'prod'
    workload: 'iot-platform'
    managedBy: 'bicep'
  }
}

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-02-01' = {
  name: recoveryVaultName
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
  tags: {
    environment: 'prod'
    workload: 'iot-platform'
    managedBy: 'bicep'
  }
}

output automationAccountId string = automation.id
output recoveryVaultId string = recoveryVault.id
