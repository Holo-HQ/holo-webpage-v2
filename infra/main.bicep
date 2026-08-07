targetScope = 'subscription'

@description('Nombre del resource group dedicado a la página web.')
param resourceGroupName string = 'holo-webpage-rg'

@description('Región de Azure donde se crea el resource group y la Static Web App.')
param location string = 'eastus2'

@description('Nombre globalmente único de la Azure Static Web App.')
param staticWebAppName string = 'holo-webpage-swa'

@description('SKU de la Static Web App. Free es suficiente para la primera migración.')
@allowed([
  'Free'
  'Standard'
])
param skuName string = 'Free'

@description('Rama de producción documentada para el despliegue.')
param productionBranch string = 'main'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: {
    app: 'holo-webpage'
    managedBy: 'bicep'
    environment: 'production'
  }
}

module staticWebApp 'static-web-app.bicep' = {
  name: 'deploy-static-web-app'
  scope: resourceGroup
  params: {
    staticWebAppName: staticWebAppName
    location: location
    skuName: skuName
    productionBranch: productionBranch
  }
}

output resourceGroupName string = resourceGroup.name
output staticWebAppName string = staticWebApp.outputs.staticWebAppName
output defaultHostname string = staticWebApp.outputs.defaultHostname
