variable "resource_group_name" {}
variable "location" {}
variable "sql_server_name" {}
variable "sql_db_name" {}
variable "admin_password" {}
variable "db_subnet_id" {}
variable "max_size_gb" {}
variable "sku_name" {}
variable "geo_backup_enabled" {
    type = bool
    default = true
}
variable "storage_account_type" {
    default = "Geo"
}
variable "public_network_access_enabled" {
    type = bool
}
variable "tags" {}