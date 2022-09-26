param prefix string
param location string
param subnetId string
param adminPublicKey string

param adminUsername string = 'aksadmin'

var name =  '${prefix}-aks'


var defaultNodePoolSettings = {
  name: 'defaultpool'
  orchestratorVersion: null

  mode: 'System'
  
  vmSize: 'Standard_D2s_v3'
  osType: 'Linux'
  osDiskSizeGB: 50
  osDiskType: 'Ephemeral'
  type: 'VirtualMachineScaleSets'
  count: 3

  vnetSubnetID: subnetId
  minCount: 2
  maxCount: 3
  maxPods: 30
  
  enableAutoScaling: true
  upgradeSettings: {
    maxSurge: '1'
  }

  tags: {}
  nodeLabels: {}
  nodeTaints: []
}

resource aks 'Microsoft.ContainerService/managedClusters@2022-07-01' = {
  name: name
  location: location
  
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  
  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    dnsPrefix: name
    enableRBAC: true
    linuxProfile: {
      adminUsername: adminUsername
      ssh: {
        publicKeys: [
          {
            keyData: adminPublicKey
          }
        ]
      }
    }

    enablePodSecurityPolicy: false

    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'calico'
      serviceCidr: '172.16.0.0/22'
      dnsServiceIP: '172.16.0.10'
      dockerBridgeCidr: '172.16.4.1/22'
      outboundType: 'userDefinedRouting'
      loadBalancerSku: 'standard'
    }

    agentPoolProfiles: [
      defaultNodePoolSettings
    ]
  }
}
