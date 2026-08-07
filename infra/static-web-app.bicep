targetScope = 'resourceGroup'

param staticWebAppName string
param location string
param skuName string
param productionBranch string

resource staticWebApp 'Microsoft.Web/staticSites@2022-09-01' = {
  name: staticWebAppName
  location: location
  sku: {
    name: skuName
    tier: skuName
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
  }
  tags: {
    app: 'holo-webpage'
    environment: 'production'
    productionBranch: productionBranch
  }
}

output staticWebAppName string = staticWebApp.name
output defaultHostname string = staticWebApp.properties.defaultHostname
