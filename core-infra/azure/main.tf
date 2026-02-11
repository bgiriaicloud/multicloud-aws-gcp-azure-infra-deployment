# VNet Module
module "vnet" {
  source = "../../modules/azure/vnet"

  azure_rg_name  = var.azure_rg_name
  azure_location = var.azure_location
}

# Application Gateway Module
module "app_gateway" {
  source = "../../modules/azure/app_gateway"

  resource_group_name = module.vnet.resource_group_name
  location            = module.vnet.location
  subnet_id           = module.vnet.public_subnet_id
}

# VM Scale Set Module
module "vmss" {
  source = "../../modules/azure/vmss"

  resource_group_name = module.vnet.resource_group_name
  location            = module.vnet.location
  subnet_id           = module.vnet.private_compute_subnet_id
  ssh_public_key      = var.ssh_public_key
  backend_pool_id     = module.app_gateway.backend_pool_id
}

# SQL Database Module
module "sql" {
  source = "../../modules/azure/sql"

  resource_group_name = module.vnet.resource_group_name
  location            = module.vnet.location
  subnet_id           = module.vnet.private_db_subnet_id
  db_password         = var.db_password
}
