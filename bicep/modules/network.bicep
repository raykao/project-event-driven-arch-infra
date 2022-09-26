param prefix string
param location string = resourceGroup().location

var apimSubnetName = 'apimSubnet'

resource apimNsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: '${prefix}-apim-nsg'
  location: location
  properties: {
    securityRules: [
      
    ]
  }
}

resource workloadNsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: '${prefix}-workload-nsg'
  location: location
  properties: {
    securityRules: [
      
    ]
  }
}

resource hubVnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: '${prefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: apimSubnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: apimNsg.id
          }
        }
      }
      {
        name: 'workloadSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: workloadNsg.id
          }
        }
      }
      {
        name: 'aksSubnet'
        properties: {
          addressPrefix: '10.0.4.0/22'
        }
      }
      {
        name: 'privateEndpointSubnet'
        properties: {
          addressPrefix: '10.0.8.0/24'
        }
      }
    ]
  }

  resource apimSubnet 'subnets' existing = {
    name: apimSubnetName
  }

  resource aksSubnet 'subnets' existing = {
    name: 'aksSubnet'
  }

  resource privateEndpointSubnet 'subnets' existing = {
    name: 'privateEndpointSubnet'
  }
}

output id string = hubVnet.id
output name string = hubvnet.name
output apimSubnetId string = hubVnet::apimSubnet.id
output aksSubnetId string = hubVnet::aksSubnet.id
output privateEndpointSubnetId string = hubVnet::privateEndpointSubnet.id
