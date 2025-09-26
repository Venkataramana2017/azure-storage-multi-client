# Values returned by the module

output "storage_account" {
  description = "Storage account details"
  value = {
    id                    = azurerm_storage_account.this.id
    name                  = azurerm_storage_account.this.name
    resource_group_name   = azurerm_storage_account.this.resource_group_name
    primary_blob_endpoint = azurerm_storage_account.this.primary_blob_endpoint
    primary_access_key    = azurerm_storage_account.this.primary_access_key
  }
  sensitive = true
}

output "resource_group" {
  description = "Resource group details"
  value = {
    id       = azurerm_resource_group.this.id
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }
}

output "private_endpoint" {
  description = "Private endpoint details (if created)"
  value = var.private_endpoint_subnet_id != null ? {
    id   = azurerm_private_endpoint.this[0].id
    name = azurerm_private_endpoint.this[0].name
  } : null
}