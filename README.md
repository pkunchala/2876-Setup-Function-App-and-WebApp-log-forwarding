# phlexrim.Infrastructure
This repository contains the Terraform code for spinning up phlexrim & phlexsubmission infrastructure.
It's owned and managed by the DevOps team.

## Prerequisites
- Terraform 0.15.3
- Azure CLI

## Quick start
1. Clone the repo.
2. Change directory into the stage you want to deploy.
3. Make sure you are signed in on the Azure CLI (`az login`).
4. Run `terraform init` to initialise.
5. You're good to go.

Please note that deployments (via `terraform apply`) should not be made
locally -- only via the deployment pipeline.

## Folder structure
- `backends/`: Terraform backend variables to be used in a pipeline with `--backend-config` 
  and secret substitution.
- `bootstrap/`: Bootstrap code to deploy infrastructure required for the whole project.
- `environments/`: Contains Terraform code to spin up the phlexrim environments.
- `modules/`: Contains common Terraform modules used across the phlexrim infrastructure.
  - `pxr_environment/`: A module for setting up a complete phlexrim environment end-to-end.
  - `azure_state_backend/`: A module for setting up state backend on Azure.
  - `key_vault/`: A module for setting up key vault service
  - `resource_group/`: A module for setting up an Azure Resource Group.
  - `identity/`: A module that creates a managed identity that can be used assign roles to azure services
  - `app_service_plan/`: A module for Azure App Service Plan
  - `webapp/`: A module for Azure App Service windows container
  - `network/`: A module for Azure Virtual Network
  - `function_app/`: A module for setting up Azure Function apps
  - `service_bus/`: A module for setting up Azure Service Bus
  - `service_bus_topic/`: A module for setting up Azure Service Bus topics
  - `storage_acoount/`: A module for setting up Azure Storage 

## Bootstrap
The `bootstrap/` folder contains Terraform code for bootstrapping the rest of the Terraform.
This solves the chicken/egg problem of needing to have infrastructure already deployed
before you deploy your infrastructure.

All it sets up at the moment is Terraform state backends for prod and dev in their
respective subscriptions. Because it will be run without state backends (as it creates
them!) it has been hardcoded to use a local state backend. We can safely just spin it
up once and forget about or delete the locally created state. It's unlikely we'll
ever need to redeploy the state backend.

The project has already been bootstrapped by the time you read this, but in the unlikely
event you need to bootstrap again, you can do it like this:
1. `cd bootstrap`
2. Create a file called `terraform.tfvars` in this directory, containing:
   ```
   dev_client_secret = "<secret>"
   prod_client_secret = "<secret>"
   ```
   Replacing `<secret>` with the secret values from the pxv-vault-eun (DevOps Bastion Subscription)
   key vault (`phlexrim-dev-sp-password` ).

   `terraform.tfvars` is included in the `.gitignore` for this repo,
   but just in case **please** run `git status` before committing to
   make sure you've not accidentally named it something wrong. It
   contains secrets so should not be put in source control.
3. `terraform init` 
4. `terraform apply`
5. After the infrastructure has been created, you will need to give
   service principals that need to access the backends 'Storage Blob Data
   Contributor' role assignments on the storage accounts. Unfortunately
   this has to be done manually via Azure portal.