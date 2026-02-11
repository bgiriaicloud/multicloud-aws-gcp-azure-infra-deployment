output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "private_compute_subnet_id" {
  value = azurerm_subnet.private_compute.id
}

output "private_db_subnet_id" {
  value = azurerm_subnet.private_db.id
}

output "location" {
  value = azurerm_resource_group.main.location
}
