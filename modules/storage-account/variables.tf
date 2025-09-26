# Input variables for the module

variable "client_name" {
  description = "Name of the client"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.client_name))
    error_message = "Client name must contain only lowercase letters and numbers."
  }
}

variable "environment" {
  description = "Environment name (dev, test, staging, prod)"
  type        = string
  
  validation {
    condition = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, staging, prod."
  }
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "storage_config" {
  description = "Storage account configuration object"
  type = object({
    account_tier             = string
    account_replication_type = string
    access_tier              = string
    enable_https_traffic     = bool
    min_tls_version         = string
    delete_retention_days   = number
  })
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint (optional)"
  type        = string
  default     = null
}
