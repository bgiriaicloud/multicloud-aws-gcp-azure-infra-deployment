terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "multi-cloud-azure-state-storage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
