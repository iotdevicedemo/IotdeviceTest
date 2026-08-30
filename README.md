# IotdeviceTest

Infrastructure as Code (IaC) repository for the IoT Device Demo on Azure.

## Architecture

GitHub Actions validates and deploys Azure resources defined in Bicep.

```text
Developer
   |
   v
GitHub Repository
   |
   +--> Bicep validation
   |
   +--> Azure Login (OIDC)
   |
   +--> Bicep What-If / Deploy
   |
   v
Azure Resource Group
   |
   +--> IoT Hub
   +--> Storage Account
```

## Repository structure

- `infra/main.bicep` - subscription-scoped entry point
- `infra/modules/` - reusable Bicep modules
- `infra/parameters/` - environment parameter files
- `.github/workflows/validate-bicep.yml` - PR validation
- `.github/workflows/deploy-dev.yml` - development deployment
- `scripts/` - helper scripts

## Naming convention

Resources use the pattern:

`<workload>-<resource>-<environment>-<region>`

Example: `iotdemo-iothub-dev-eus`

Avoid storing Azure credentials, client secrets, or connection strings in Git. GitHub Actions should authenticate to Azure using OIDC / workload identity federation.

## Required GitHub configuration

Configure these repository variables before enabling deployment:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_LOCATION`

The Azure federated identity must trust this GitHub repository and its deployment branch/environment according to the organization's security policy.
