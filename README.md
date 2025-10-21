# Intro to Cloud SET

Homeworks for Intro to Cloud SET course

## Setup

1. **Bootstrap backend** (one time):
   - Actions → "Terraform Backend Bootstrap" → Run workflow
   - Save the storage account name from output

2. **Update backend config** in `terraform/main.tf`:
   ```hcl
   backend "azurerm" {
     resource_group_name  = "rg-tfstate"
     storage_account_name = "settfstateXXXXXX"  # Use actual name
     container_name       = "tfstate"
     key                  = "terraform.tfstate"
   }
   ```

## Deploy

Actions → "Terraform Deploy" → Run workflow:
- **Branch**: Choose branch to deploy
- **Action**: `plan` (preview) or `apply` (deploy)

## Secrets Required

Settings → Secrets → Actions:
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

## Project Structure

```
├── .github/workflows/
│   ├── terraform-bootstrap.yml  # Create backend
│   └── terraform-deploy.yml     # Deploy infrastructure
└── terraform/
    ├── main.tf                  # Provider & backend config
    └── ...                      # Your infrastructure code
```

Done! 🚀
