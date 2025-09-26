variable "clients" {
  description = "List of client names"
  type        = list(string)
  default     = ["client1", "client2", "client3"]
  
  validation {
    condition = alltrue([
      for client in var.clients : can(regex("^[a-z0-9]+$", client))
    ])
    error_message = "All client names must contain only lowercase letters and numbers."
  }
}

variable "environments" {
  description = "List of environments"
  type        = list(string)
  default     = ["dev", "test", "staging", "prod"]
  
  validation {
    condition = alltrue([
      for env in var.environments : contains(["dev", "test", "staging", "prod"], env)
    ])
    error_message = "All environments must be one of: dev, test, staging, prod."
  }
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoints (required for production)"
  type        = string
  default     = null
}
