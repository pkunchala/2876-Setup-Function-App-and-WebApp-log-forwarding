# azure_state_backend
A Terraform module for creating a Terraform state backend as an Azure Storage Account.

## Variables
| Variable      | Description                                                                     | Type        | Note     |
| ------------- | ------------------------------------------------------------------------------- | ----------- | -------- |
| `location`    | The Azure location to create the state backend container in.                    | string      | Required |
| `environment` | The environment that this state backend serves (i.e. prod). Goes into its name. | string      | Required |
| `name`        | The name of this state backend.                                                 | string      | Required |
| `tags`        | The tags to put on state backend components.                                    | map(string) | Required |

## Example
```
module "example" {
  source = "../modules/azure_state_backend"

  name        = "tfstate-phlexrim"
  location    = "North Europe"
  environment = "dev"
  tags = {
    owner       = "devOps"
    environment = "dev"
    service     = "terraform"
    product     = "general"
    name        = "statebackend"
  }
}
```

Would the following resources:
- Resource group: `rg-tfstate-phlexrim-dev`
- Storage account: `tfstatephlexrimdev` 
