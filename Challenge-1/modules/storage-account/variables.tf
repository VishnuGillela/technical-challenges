variable "storage_account_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "container_name_list" {
  type = list(string)
  default = []
}

variable "account_kind" {}
variable "account_tier" {}
variable "replication_type" {}
variable "allow_nested_items_to_be_public" {}
variable "public_network_access_enabled" {}
variable "web_subnet_id" {}
variable "tags" {}