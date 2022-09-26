param prefix string
param location string
param adminEmail string
param adminName string
param subnetId string
param skuName string = 'Developer'
param skuCapacity int = 1

resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: '${prefix}-apim'
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    publisherEmail: adminEmail
    publisherName: adminName
    virtualNetworkConfiguration: {
      subnetResourceId: subnetId
    }
    virtualNetworkType: 'External'
  }
}
