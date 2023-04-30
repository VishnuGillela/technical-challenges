variable "prefix" {
  default = "vi"
}

variable "location" {
    default = "Central US"
}
variable "region" {}
variable "env" {}

#Network variables
variable "vnet_base_cidr" {
    type = list(string)
}
variable "subnets" {
  type = map(object({
    subnet_cidr = string
    network_policies = bool
    delegation = string
   }))
   default = {}
}

variable "subnet_without_delegation" {
  type = map(object({
    subnet_cidr = string
    network_policies = bool
   }))
   default = {}
}

variable application_tags {
    default = {
        "environment" = "DEV"
        "businessUnit" = "Test"
        "SupportTeam" = "TBD"
    }
}

variable webapp_sku {}
variable "web_subnet_id" {}
variable "webapp_backup_retention_in_days" {}
variable "webapp_private_link_subnet_id" {}
variable "app_subnet_id" {}
variable "db_subnet_id" {}

variable "container_list" {
  type = list(string)
  default = []
}

variable "account_kind" {}
variable "account_tier" {}
variable "replication_type" {}
variable "allow_nested_items_to_be_public" {}
variable "public_network_access_enabled" {}

variable "key_vault_name" {}
variable "vm_password_key_vault_secret_name" {}
variable "key_vault_rg" {}
variable "vm_size" {}
variable "data_disk" {
    type = bool
    default = false
}
variable "disk_storage_account_type" {}
variable "data_disk_in_gb" {}

variable "sql_server_name" {}
variable "sql_db_name" {}
variable "mssql_max_size_gb" {}
variable "mssql_sku_name" {}
variable "mssql_admin_password_secret_name" {}
variable "mssql_geo_backup_enabled" {
    type = bool
    default = true
}
variable "mssql_storage_account_type" {
    default = "Geo"
}
variable "mssql_public_network_access_enabled" {
    type = bool
}