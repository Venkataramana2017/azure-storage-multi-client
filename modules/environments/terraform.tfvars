# Example configuration - copy to terraform.tfvars

# List of clients to create storage accounts for
clients = [
  "acmecorp",
  "techstart", 
  "bizflow"
]

# Environments to create (dev, test, staging, prod supported)
environments = ["dev", "test", "staging", "prod"]

# Azure region for all resources
location = "East US"