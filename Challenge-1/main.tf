terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.54.0"
    }
  }

  backend "local" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}



resource "azurerm_resource_group" "web-rg" {
  name = "${var.prefix}-${var.region}-${var.env}-web-rg"
  location = var.location
  tags = var.application_tags
}

resource "azurerm_resource_group" "app-rg" {
  name = "${var.prefix}-${var.region}-${var.env}-app-rg"
  location = var.location
  tags = var.application_tags
}

resource "azurerm_resource_group" "db-rg" {
  name = "${var.prefix}-${var.region}-${var.env}-db-rg"
  location = var.location
  tags = var.application_tags
}

resource "azurerm_resource_group" "network-rg" {
  name = "${var.prefix}-${var.region}-${var.env}-network-rg"
  location = var.location
  tags = var.application_tags
}

module "vnet" {
  source = "./modules/network"
  network_name = "${var.prefix}-${var.region}-${var.env}-vnet"
  network_rg_name = azurerm_resource_group.network-rg.name
  location = var.location
  subnets = var.subnets
  subnet_without_delegation = var.subnet_without_delegation
  vnet_base_cidr = var.vnet_base_cidr
  tags = var.application_tags
}

#Storage acconut for storing web app backups
module "atcstorageaccount" {
  source = "./modules/storage-account"
  storage_account_name = "${var.prefix}${var.region}${var.env}atcstr"
  resource_group_name = azurerm_resource_group.web-rg.name
  location = var.location
  container_name_list = var.container_list
  account_kind = var.account_kind
  account_tier = var.account_tier
  replication_type = var.replication_type
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  public_network_access_enabled = var.public_network_access_enabled
  web_subnet_id = var.web_subnet_id
  tags = var.application_tags
  depends_on = [module.vnet.vnet_id]
}

#Web App 01

module "webapp01" {
  source = "./modules/webapp"
  resource_group_name = azurerm_resource_group.web-rg.name
  location = var.location
  asp_os_type = "Windows"
  asp_name = "${var.prefix}-${var.region}-${var.env}-asp001"
  webapp_name = "${var.prefix}-${var.region}-${var.env}-app001"
  sku = var.webapp_sku
  backup_retention_in_days = var.webapp_backup_retention_in_days
  subnet_id = var.web_subnet_id
  private_link_name = "${var.prefix}-${var.region}-${var.env}-app001-plink"
  private_link_subnet_id = var.webapp_private_link_subnet_id
  tags = var.application_tags
  depends_on = [module.vnet.vnet_id]
}


#VM

#Get vm_admin_password from key vault
data "azurerm_key_vault" "kv" {
  name = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "kv_secret" {
  name = var.vm_password_key_vault_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

module "web_vms" {
  source = "./modules/virtualmachine"
  resource_group_name = azurerm_resource_group.web-rg.name
  location = azurerm_resource_group.web-rg.location
  num_vms = 1
  vm_name_prefix = "${var.prefix}-${var.env}-atc-app" #'atc' is application name 
  vm_subnet_id = var.app_subnet_id
  vm_size = var.vm_size
  data_disk = var.data_disk
  admin_password = data.azurerm_key_vault_secret.kv_secret.value
  data_disk_in_gb = var.data_disk_in_gb
  disk_storage_account_type = var.disk_storage_account_type
  storage_account_uri = "${module.atcstorageaccount.storage_account_uri}"
  tags = var.application_tags
  depends_on = [module.vnet, module.atcstorageaccount]
}

#MSSQL

data "azurerm_key_vault_secret" "mssql_kv_secret" {
  name = var.mssql_admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

module "mssql" {
  source = "./modules/az-sql-database"
  resource_group_name = azurerm_resource_group.db-rg.name
  location = azurerm_resource_group.db-rg.location
  sql_server_name = "${var.prefix}-${var.env}-atc-sqlserver"
  sql_db_name = "${var.prefix}-${var.env}-atc-db"
  admin_password = data.azurerm_key_vault_secret.mssql_kv_secret.value
  db_subnet_id = var.db_subnet_id
  max_size_gb = var.mssql_max_size_gb
  sku_name = var.mssql_sku_name
  geo_backup_enabled = var.mssql_geo_backup_enabled
  storage_account_type = var.mssql_storage_account_type
  public_network_access_enabled = var.mssql_public_network_access_enabled
  tags = var.application_tags
  depends_on = [module.vnet]
}