param virtualNetworks_ResearchVnet_name string = 'ResearchVnet'
param virtualNetworks_CoreServicesVnet_name string = 'CoreServicesVnet'
param virtualNetworks_ManufacturingVnet_name string = 'ManufacturingVnet'
param CoreServices_location string = 'eastus'
param Manufacturing_location string = 'westeurope'
param Research_location string = 'southeastasia'
param global_location string = 'global'
@description('description')
param vmName1 string

@description('description')
param nicName1 string

@description('description')
param manvmName1 string

@description('description')
param mannicName1 string

@description('description')
param vmName2 string

@description('description')
param nicName2 string

@description('Virtual machine size')
param vmSize string = 'Standard_D2s_v3'

@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

var nsgName1_var = 'testvm1-nsg'
var nsgName2_var = 'testvm2-nsg'
var PIPName1_var = 'testvm1-pip'
var PIPName2_var = 'testvm2-pip'
var mannsgName1_var = 'ManufacturingVM-nsg'
var manPIPName1_var = 'ManufacturingVM-ip'


param resourceTags object = {
  project: 'az-700'
  environment: 'test'
  owner: 'dalehirt@microsoft.com'
}

param utcValue string = utcNow()
var tags = union(resourceTags, {
  lastDeployed: utcValue
})

resource virtualNetworks_CoreServicesVnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_CoreServicesVnet_name
  location: CoreServices_location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.20.0.0/27'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SharedServicesSubnet'
        properties: {
          addressPrefix: '10.20.10.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'DatabaseSubnet'
        properties: {
          addressPrefix: '10.20.20.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'PublicWebServiceSubnet'
        properties: {
          addressPrefix: '10.20.30.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_ManufacturingVnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_ManufacturingVnet_name
  location: Manufacturing_location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ManufacturingSystemSubnet'
        properties: {
          addressPrefix: '10.30.10.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SensorSubnet1'
        properties: {
          addressPrefix: '10.30.20.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SensorSubnet2'
        properties: {
          addressPrefix: '10.30.21.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SensorSubnet3'
        properties: {
          addressPrefix: '10.30.22.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_ResearchVnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_ResearchVnet_name
  location: Research_location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ResearchSystemSubnet'
        properties: {
          addressPrefix: '10.40.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_CoreServicesVnet_name_DatabaseSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_CoreServicesVnet_name_resource
  name: 'DatabaseSubnet'
  properties: {
    addressPrefix: '10.20.20.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_CoreServicesVnet_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_CoreServicesVnet_name_resource
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: '10.20.0.0/27'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_ManufacturingVnet_name_ManufacturingSystemSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_ManufacturingVnet_name_resource
  name: 'ManufacturingSystemSubnet'
  properties: {
    addressPrefix: '10.30.10.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_CoreServicesVnet_name_PublicWebServiceSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_CoreServicesVnet_name_resource
  name: 'PublicWebServiceSubnet'
  properties: {
    addressPrefix: '10.20.30.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_ResearchVnet_name_ResearchSystemSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_ResearchVnet_name_resource
  name: 'ResearchSystemSubnet'
  properties: {
    addressPrefix: '10.40.40.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_ManufacturingVnet_name_SensorSubnet1 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_ManufacturingVnet_name_resource
  name: 'SensorSubnet1'
  properties: {
    addressPrefix: '10.30.20.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_ManufacturingVnet_name_SensorSubnet2 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_ManufacturingVnet_name_resource
  name: 'SensorSubnet2'
  properties: {
    addressPrefix: '10.30.21.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_ManufacturingVnet_name_SensorSubnet3 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_ManufacturingVnet_name_resource
  name: 'SensorSubnet3'
  properties: {
    addressPrefix: '10.30.22.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_CoreServicesVnet_name_SharedServicesSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_CoreServicesVnet_name_resource
  name: 'SharedServicesSubnet'
  properties: {
    addressPrefix: '10.20.10.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource privateDns_module 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'Contoso.com'
  location: global_location
  tags: tags
}

resource CoreServicesVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'CoreServicesVnetLink'
  parent: privateDns_module
  location: global_location
  tags: tags
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_CoreServicesVnet_name_resource.id
    }
  }
}

resource ManufacturingVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'ManufacturingVnetLink'
  parent: privateDns_module
  location: global_location
  tags: tags
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_ManufacturingVnet_name_resource.id
    }
  }
}

resource ResearchVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'ResearchVnetLink'
  parent: privateDns_module
  location: global_location
  tags: tags
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_ResearchVnet_name_resource.id
    }
  }
}


resource vmName1_resource 'Microsoft.Compute/virtualMachines@2018-06-01' = {
  name: vmName1
  location: CoreServices_location
  tags: tags
  properties: {
    osProfile: {
      computerName: vmName1
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nicName1_resource.id
        }
      ]
    }
  }
}

resource nicName1_resource 'Microsoft.Network/networkInterfaces@2018-08-01' = {
  name: nicName1
  location: CoreServices_location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetworks_CoreServicesVnet_name_DatabaseSubnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: PIPName1.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgName1.id
    }
  }
}

resource nsgName1 'Microsoft.Network/networkSecurityGroups@2018-08-01' = {
  name: nsgName1_var
  location: CoreServices_location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vmName2_resource 'Microsoft.Compute/virtualMachines@2018-06-01' = {
  name: vmName2
  location: CoreServices_location
  tags: tags
  properties: {
    osProfile: {
      computerName: vmName2
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nicName2_resource.id
        }
      ]
    }
  }
}

resource nicName2_resource 'Microsoft.Network/networkInterfaces@2018-08-01' = {
  name: nicName2
  location: CoreServices_location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetworks_CoreServicesVnet_name_DatabaseSubnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: PIPName2.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgName2.id
    }
  }
}

resource nsgName2 'Microsoft.Network/networkSecurityGroups@2018-08-01' = {
  name: nsgName2_var
  location: CoreServices_location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource PIPName1 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: PIPName1_var
  location: CoreServices_location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource PIPName2 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: PIPName2_var
  location: CoreServices_location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}


resource manvmName1_resource 'Microsoft.Compute/virtualMachines@2018-06-01' = {
  name: manvmName1
  location: Manufacturing_location
  properties: {
    osProfile: {
      computerName: manvmName1
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: mannicName1_resource.id
        }
      ]
    }
  }
}

resource mannicName1_resource 'Microsoft.Network/networkInterfaces@2018-08-01' = {
  name: mannicName1
  location: Manufacturing_location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetworks_ManufacturingVnet_name_ManufacturingSystemSubnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: manPIPName1.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: mannsgName1.id
    }
  }
}

resource mannsgName1 'Microsoft.Network/networkSecurityGroups@2018-08-01' = {
  name: mannsgName1_var
  location: Manufacturing_location
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource manPIPName1 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: manPIPName1_var
  location: Manufacturing_location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: virtualNetworks_CoreServicesVnet_name_resource
  name: '${virtualNetworks_CoreServicesVnet_name}-${virtualNetworks_ManufacturingVnet_name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: virtualNetworks_ManufacturingVnet_name_resource.id
    }
  }
}

resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: virtualNetworks_ManufacturingVnet_name_resource
  name: '${virtualNetworks_ManufacturingVnet_name}-${virtualNetworks_CoreServicesVnet_name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: virtualNetworks_CoreServicesVnet_name_resource.id
    }
  }
}
