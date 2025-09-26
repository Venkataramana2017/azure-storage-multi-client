# infor about the moudles and layer so that reuasable modules to provision the Azure cloud resorunces 

# azure-storage-multi-client
new repo
1. **Module Definition** (`modules/storage-account/`):
   - Self-contained unit that creates: Resource Group + Storage Account + Private Endpoint
   - Takes inputs like client_name, environment, storage_config
   - Returns outputs like storage account details

2. **Module Usage** (`environments/main.tf`):
   - Calls the storage-account module multiple times
   - Uses `for_each` to create one instance per client-environment combination
   - Passes different configurations based on environment

### Usage

1. **Deploy Everything**:
```bash
cd environments
terraform init
terraform plan
terraform apply
```