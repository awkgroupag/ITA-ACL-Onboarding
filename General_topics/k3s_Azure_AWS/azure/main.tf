# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

#-----------------------------------------------------------------------
# create a new resource group which contains all resources for this test
resource "azurerm_resource_group" "rg" {
  name     = "rg-euwe-${var.env}-${var.project}"
  location = "westeurope"

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }  
}

#-----------------------------------------------------------------------
# create a new VNET inside this new group
resource "azurerm_virtual_network" "vn1" {
  name = "vn-euwe-${var.env}-${var.project}-vn1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["${var.cidr_azure_vnet}"]

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }    
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefixes = [ "${var.cidr_azure_subnet}" ]
} 

# create GatewaySubnet 
resource "azurerm_subnet" "gw-subnet" {
  name = "GatewaySubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefixes = [ "${var.cidr_azure_gateway_subnet}" ]
}

#-----------------------------------------------------------------------
# create a public IP address to access the VNET/Gateway
resource "azurerm_public_ip" "pip-azure-vpn-gw" {
  name                = "pip-azure-vpn-gw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }
}

# create virtual network gateway
resource "azurerm_virtual_network_gateway" "vng" {
  name                = "vng"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip-azure-vpn-gw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gw-subnet.id
  }

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }
}
output "pip-azure-vpn-gw" {
  value = "${azurerm_virtual_network_gateway.vng.bgp_settings[0].peering_addresses[0].tunnel_ip_addresses[0]}"
}

#-----------------------------------------------------------------------
# create local gateway(s)
resource "azurerm_local_network_gateway" "lgw-aws1" {
  name = "${var.project}-aws-local-gateway-1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gateway_address = "${var.pip-aws-vpn-gw-tunnel1}" # public IP of AWS VPG
  address_space = [ "${var.cidr_aws_vpc}" ]

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }
}
resource "azurerm_local_network_gateway" "lgw-aws2" {
  name = "${var.project}-aws-local-gateway-2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gateway_address = "${var.pip-aws-vpn-gw-tunnel2}" # public IP of AWS VPG
  address_space = [ "${var.cidr_aws_vpc}" ]

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }
}

#-----------------------------------------------------------------------
# create connection(s) on virtual network gateway
resource "azurerm_virtual_network_gateway_connection" "tunnel1" {
  name                = "aws-tunnel1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vng.id
  local_network_gateway_id   = azurerm_local_network_gateway.lgw-aws1.id
  connection_protocol = "IKEv2"

  # shared key from AWS tunnel1
  shared_key = "${var.vpn-conn-tunnel1-psk}"

  depends_on = [
    azurerm_local_network_gateway.lgw-aws1
  ]

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }
} 
resource "azurerm_virtual_network_gateway_connection" "tunnel2" {
  name                = "aws-tunnel2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vng.id
  local_network_gateway_id   = azurerm_local_network_gateway.lgw-aws2.id
  connection_protocol = "IKEv2"

  # shared key from AWS tunnel2
  shared_key = "${var.vpn-conn-tunnel2-psk}"

  depends_on = [
    azurerm_local_network_gateway.lgw-aws2
  ]

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }
}


#-----------------------------------------------------------------------
# create VMs which are attached to the internal VNET

# VM1 have a public IP address to access the VM
resource "azurerm_public_ip" "vm1-public" {
  name                = "vm1-public"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }
}

resource "azurerm_network_interface" "vm1-nic" {
  name                = "vm1-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.1.1.10"
    public_ip_address_id = azurerm_public_ip.vm1-public.id
  }

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }  
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                            = "vm1"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  #size                            = "Standard_B1s" # 1 vCPU, 1 GB RAM
  size                            = "Standard_B1ms" # 1 vCPU, 2 GB RAM
  admin_username                  = "${var.username}"
  network_interface_ids = [
    azurerm_network_interface.vm1-nic.id,
  ]

  admin_ssh_key {
    username = "${var.username}"
    public_key = file("~/.ssh/id_${var.username}.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }  
}

# VM2 have a public IP address to access the VM
resource "azurerm_public_ip" "vm2-public" {
  name                = "vm2-public"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }
}

resource "azurerm_network_interface" "vm2-nic" {
  name                = "vm2-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.1.1.20"
    public_ip_address_id = azurerm_public_ip.vm2-public.id
  }

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }  
}

resource "azurerm_linux_virtual_machine" "vm2" {
  name                            = "vm2"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  #size                            = "Standard_B1s" # 1 vCPU, 1 GB RAM
  size                            = "Standard_B1ms" # 1 vCPU, 2 GB RAM
  admin_username                  = "${var.username}"
  network_interface_ids = [
    azurerm_network_interface.vm2-nic.id,
  ]

  admin_ssh_key {
    username = "${var.username}"
    public_key = file("~/.ssh/id_${var.username}.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "${var.env}"
    owner = "${var.email}"
    project = "${var.project}"
  }  
}

