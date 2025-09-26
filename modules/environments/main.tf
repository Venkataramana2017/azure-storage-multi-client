# Root module that calls the storage-account module multiple times

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Local configuration
locals {
  # Define all clients and environments
  clients      = var.clients
  environments = var.environments
  
  # Create all client-environment combinations
  client_environments = flatten([
    for client in local.clients : [
      for env in local.environments : {
        client      = client
        environment = env
        key         = "${client}-${env}"
      }
    ]
  ])
  
  # Environment-specific storage configurations
  storage_configs = {
    dev = {
      account_tier             = "Standard"
      account_replication_type = "LRS"
      access_tier              = "Hot"
      enable_https_traffic     = true
      min_tls_version         = "TLS1_2"
      delete_retention_days   = 7
    }
    test = {
      account_tier             = "Standard"
      account_replication_type = "LRS"
      access_tier              = "Hot"
      enable_https_traffic     = true
      min_tls_version         = "TLS1_2"
      delete_retention_days   = 7
    }
    staging = {
      account_tier             = "Standard"
      account_replication_type = "GRS"
      access_tier              = "Hot"
      enable_https_traffic     = true
      min_tls_version         = "TLS1_2"
      delete_retention_days   = 30
    }
    prod = {
      account_tier             = "Premium"
      account_replication_type = "ZRS"
      access_tier              = "Hot"
      enable_https_traffic     = true
      min_tls_version         = "TLS1_2"
      delete_retention_days   = 90
    }
  }
  
  # Common tags
  common_tags = {
    ManagedBy   = "Terraform"
    Project     = "Multi-Client Storage"
    Owner       = "Infrastructure Team"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  }
}

# Call the storage-account module for each client-environment combination
module "client_storage" {
  source = "../modules/storage-account"
  
  # Create one module instance for each client-environment combo
  for_each = { for ce in local.client_environments : ce.key => ce }
  
  # Pass variables to the module
  client_name  = each.value.client
  environment  = each.value.environment
  location     = var.location
  
  # Pass the appropriate storage config for this environment
  storage_config = local.storage_configs[each.value.environment]
  
  # Pass common tags
  common_tags = local.common_tags
  
  # Only create private endpoints for production
  private_endpoint_subnet_id = each.value.environment == "prod" ? var.private_endpoint_subnet_id : null
}