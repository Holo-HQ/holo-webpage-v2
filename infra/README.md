# Azure Static Web Apps

## Provisionar la infraestructura

Requiere Azure CLI autenticado y permisos para crear recursos en la suscripción de HOLO:

```powershell
az login
az account set --subscription "<HOLO_SUBSCRIPTION_ID_OR_NAME>"
az deployment sub create `
  --location eastus2 `
  --template-file infra/main.bicep `
  --parameters resourceGroupName=holo-webpage-rg staticWebAppName=holo-webpage-swa
```

El despliegue devuelve `defaultHostname`, que sirve para validar Azure antes de cambiar el dominio.

## Configurar el secreto de GitHub

Obtén el token de despliegue de la Static Web App y guárdalo en el repositorio de GitHub como:

`AZURE_STATIC_WEB_APPS_API_TOKEN`

```powershell
az staticwebapp secrets list `
  --name holo-webpage-swa `
  --resource-group holo-webpage-rg `
  --query properties.apiKey `
  --output tsv
```

El workflow `.github/workflows/azure-static-web-apps.yml` publica la raíz del repositorio en cada push a `main`. No se requiere build porque el sitio es HTML/CSS/JavaScript estático.

## Validación previa al cambio DNS

Comprueba la URL temporal de Azure y valida las páginas, assets multimedia, archivos JSON, redirecciones `/landing` y `/landing.html`, headers de seguridad y caché. Netlify debe permanecer activo hasta completar esta verificación.
