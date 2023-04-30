#Base variables
prefix = "vi"
region = "wus"
env = "d"
location = "West US"
application_tags = {
        "environment" = "DEV"
        "businessUnit" = "Test"
        "SupportTeam" = "TBD"
}

#Network variables 
vnet_base_cidr = ["10.0.0.0/16"]
subnets = {
    "web-subnet" = {
        subnet_cidr = "10.0.1.0/24"
        network_policies = true
        delegation = "Microsoft.Web/serverFarms"
    }
}

subnet_without_delegation = {
    "private-link-subnet" = {
        subnet_cidr = "10.0.4.0/24"
        network_policies = false
    }
    "app-subnet" = {
        subnet_cidr = "10.0.2.0/24"
        network_policies = true
    }
    "db-subnet" = {
        subnet_cidr = "10.0.3.0/24"
        network_policies = true
    }
}
web_subnet_id = "/subscriptions/7d9ca5c3-8902-4fb4-85ff-297289242c6e/resourceGroups/vi-wus-d-network-rg/providers/Microsoft.Network/virtualNetworks/vi-wus-d-vnet/subnets/web-subnet"
webapp_private_link_subnet_id = "/subscriptions/7d9ca5c3-8902-4fb4-85ff-297289242c6e/resourceGroups/vi-wus-d-network-rg/providers/Microsoft.Network/virtualNetworks/vi-wus-d-vnet/subnets/private-link-subnet"
app_subnet_id = "/subscriptions/7d9ca5c3-8902-4fb4-85ff-297289242c6e/resourceGroups/vi-wus-d-network-rg/providers/Microsoft.Network/virtualNetworks/vi-wus-d-vnet/subnets/app-subnet"
db_subnet_id = "/subscriptions/7d9ca5c3-8902-4fb4-85ff-297289242c6e/resourceGroups/vi-wus-d-network-rg/providers/Microsoft.Network/virtualNetworks/vi-wus-d-vnet/subnets/db-subnet"
webapp_backup_retention_in_days = 14
webapp_sku = "S1"

container_list = ["webappbackups"]
account_kind = "StorageV2"
account_tier = "Standard"
replication_type = "LRS"
allow_nested_items_to_be_public = true
public_network_access_enabled = true

key_vault_name = "vi-cus-d-kv"
key_vault_rg = "vi-cus-d-kv"
vm_password_key_vault_secret_name = "windows-vm-admin-password"
vm_size = "Standard_D1"
data_disk = true
data_disk_in_gb = 128
disk_storage_account_type = "Standard_LRS"

sql_server_name = "vi-cus-d-atc-sqlserver"
sql_db_name = "vi-cus-d-atc-db"
mssql_admin_password_secret_name = "mssql-admin-password"
mssql_max_size_gb = 1
mssql_sku_name = "S0"
mssql_geo_backup_enabled = true
mssql_storage_account_type = "Geo"
mssql_public_network_access_enabled = true
