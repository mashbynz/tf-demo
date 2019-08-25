provider "azurerm" {
  version = "=1.28.0"
}

terraform {
  backend "azurerm" {}
  required_version = ">= 0.12"
}

# Resource Group
resource "azurerm_resource_group" "test" {
  name     = "demo-rg"
  location = var.primaryLocation

  tags = {
    environment = "Dev"
    application = "Australia East VM demo"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "test" {
  name                = "demo-vnet"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
  }
}

# Subnets
resource "azurerm_subnet" "Gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefix       = "10.0.0.0/24"
}

resource "azurerm_subnet" "VirtualMachines" {
  name                 = "VirtualMachines-sn"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefix       = "10.0.1.0/24"
}

# Virtual Machine NIC
resource "azurerm_network_interface" "test" {
  name                = "demoVM-nic"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                          = "VMConfig1"
    subnet_id                     = azurerm_subnet.VirtualMachines.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine Compute
resource "azurerm_virtual_machine" "test" {
  name                  = "demoVM-vm"
  location              = azurerm_resource_group.test.location
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = [azurerm_network_interface.test.id]
  vm_size               = "Standard_B1ls"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
