variable "network_name" { }
variable "network_rg_name" {}
variable "location" {}
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

variable "tags" {}