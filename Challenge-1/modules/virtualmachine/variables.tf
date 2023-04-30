variable "num_vms" {}
variable "vm_name_prefix" {}
variable "vm_subnet_id" {}
variable "resource_group_name" {}
variable "location" {}
variable "vm_size" {}
variable "admin_password" {}
variable "data_disk" {
    type = bool
    default = false
}
variable "disk_storage_account_type" {}
variable "data_disk_in_gb" {}
variable "tags" {}
variable "storage_account_uri" {}
