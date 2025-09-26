output "all_storage_accounts" {
  description = "All storage accounts organized by client and environment"
  value = {
    for key, module_output in module.client_storage : key => {
      storage_account = module_output.storage_account
      resource_group  = module_output.resource_group
      private_endpoint = module_output.private_endpoint
      client          = split("-", key)[0]
      environment     = split("-", key)[1]
    }
  }
  sensitive = true
}

output "summary" {
  description = "Summary of created resources"
  value = {
    total_storage_accounts = length(module.client_storage)
    clients_count         = length(var.clients)
    environments_count    = length(var.environments)
    
    by_client = {
      for client in var.clients : client => [
        for key, _ in module.client_storage : split("-", key)[1]
        if split("-", key)[0] == client
      ]
    }
    
    by_environment = {
      for env in var.environments : env => [
        for key, _ in module.client_storage : split("-", key)[0]
        if split("-", key)[1] == env
      ]
    }
  }
}