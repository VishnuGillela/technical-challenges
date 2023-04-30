#NIC
resource "azurerm_network_interface" "nic" {
  count = var.num_vms
  name = "${var.vm_name_prefix}-nic${format("%02d", count.index + 1)}"
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name_prefix}-ip${format("%02d", count.index + 1)}"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}

resource "azurerm_availability_set" "avset" {
  name = "${var.vm_name_prefix}-avset"
  location = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}


resource "azurerm_windows_virtual_machine" "windows_vm" {
  count = var.num_vms
  name = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
  location = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size = var.vm_size
  admin_username = "vm_admin"
  admin_password = var.admin_password
  os_disk {
    caching = "ReadWrite"
    storage_account_type = var.disk_storage_account_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }
  tags = var.tags
}

resource "azurerm_managed_disk" "data_disks" {
  count = var.data_disk ? var.num_vms : 0
  name = "${azurerm_windows_virtual_machine.windows_vm[count.index].name}-disk${count.index + 1}"
  location = var.location
  resource_group_name = var.resource_group_name
  storage_account_type = var.disk_storage_account_type
  create_option = "Empty"
  disk_size_gb = var.data_disk_in_gb
  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "disks_attachment" {
  count = var.data_disk ? var.num_vms : 0
  managed_disk_id = azurerm_managed_disk.data_disks[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.windows_vm[count.index].id
  lun = "10"
  caching = "ReadWrite"
}