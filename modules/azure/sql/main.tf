resource "azurerm_mssql_server" "main" {
  name                         = "azure-sql-server-${random_string.suffix.result}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.db_password

  tags = {
    Name = "azure-sql-server"
  }
}

resource "azurerm_mssql_database" "main" {
  name           = "azure-sql-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  sku_name       = "Basic"
  zone_redundant = false

  tags = {
    Name = "azure-sql-database"
  }
}

resource "azurerm_private_endpoint" "sql" {
  name                = "sql-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "sql-private-connection"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  tags = {
    Name = "azure-sql-private-endpoint"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
