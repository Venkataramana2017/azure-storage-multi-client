# This is the reusable module that creates storage account + resource group

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Random suffix to ensure globally unique storage account names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.client_name}-${var.environment}"
  location = var.location
  
  tags = merge(var.common_tags, {
    Client      = var.client_name
    Environment = var.environment
  })
}

# Storage Account
resource "azurerm_storage_account" "this" {
  name                = "st${var.client_name}${var.environment}${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  
  account_tier             = var.storage_config.account_tier
  account_replication_type = var.storage_config.account_replication_type
  access_tier              = var.storage_config.access_tier
  
  enable_https_traffic_only = var.storage_config.enable_https_traffic
  min_tls_version          = var.storage_config.min_tls_version
  
  # Security configurations
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  
  # Blob properties with retention
  blob_properties {
    delete_retention_policy {
      days = var.storage_config.delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_config.delete_retention_days
    }
  }
  
  tags = merge(var.common_tags, {
    Client      = var.client_name
    Environment = var.environment
    Purpose     = "Client Data Storage"
  })
}

# Optional: Private Endpoint (only created if subnet_id is provided)
resource "azurerm_private_endpoint" "this" {
  count = var.private_endpoint_subnet_id != null ? 1 : 0
  
  name                = "pe-${azurerm_storage_account.this.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.private_endpoint_subnet_id
  
  private_service_connection {
    name                           = "psc-${azurerm_storage_account.this.name}"
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  
  tags = merge(var.common_tags, {
    Client      = var.client_name
    Environment = var.environment
  })
}
