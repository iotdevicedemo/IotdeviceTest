@description('Azure region.')
param location string

@description('Virtual network name.')
param vnetName string

@description('Address space for the production spoke VNet.')
param addressSpace array = [
  '10.20.0.0/16'
]

@description('Subnet prefix for application workloads.')
param appSubnetPrefix string = '10.20.1.0/24'

@description('Subnet prefix for private endpoints.')
param privateEndpointSubnetPrefix string = '10.20.2.0/24'

@description('Subnet prefix for private endpoints used by data services.')
param dataSubnetPrefix string = '10.20.3.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace
    }
    subnets: [
      {
        name: 'snet-app-prod-eus'
        properties: {
          addressPrefix: appSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'snet-pe-prod-eus'
        properties: {
          addressPrefix: privateEndpointSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'snet-data-prod-eus'
        properties: {
          addressPrefix: dataSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
  tags: {
    environment: 'prod'
    managedBy: 'bicep'
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
output privateEndpointSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'snet-pe-prod-eus')
output appSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'snet-app-prod-eus')
output dataSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'snet-data-prod-eus')
