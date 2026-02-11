output "backend_pool_id" {
  value = azurerm_application_gateway.main.backend_address_pool[0].id
}

output "public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}
