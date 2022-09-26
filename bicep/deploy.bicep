@maxLength(10)
param prefix string
param location string
param adminEmail string
param adminName string
param adminPublicKey string

targetScope = 'subscription'

resource hubResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}-rg'
  location: location
}

module network 'modules/network.bicep' = {
  name: 'networkModule'
  scope: hubResourceGroup
  params: {
    prefix: prefix
    location: hubResourceGroup.location
  }
}

module apim 'modules/apim.bicep' = {
  name: 'apimModule'
  scope: hubResourceGroup
  params: {
    prefix: prefix
    location: location
    adminEmail: adminEmail
    adminName: adminName
    subnetId: network.outputs.apimSubnetId
  } 
}

module aks 'modules/aks.bicep' = {
  name: 'aksModule'
  scope: hubResourceGroup
  params: {
    prefix: prefix
    location: location
    subnetId: network.outputs.aksSubnetId
    adminPublicKey: adminPublicKey
  }
}
