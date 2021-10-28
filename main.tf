# Provider Block
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = ""
  location = "East US"
}

# Azure Public IP
resource "azurerm_public_ip" "pip001" {
  name                = ""
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]  
}

# Azure Public IP Prefix
resource "azurerm_public_ip_prefix" "pre001" {
  name                = ""
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 30
  zones               = ["1"]
}

# Azure NAT Gateway
resource "azurerm_nat_gateway" "ng001" {
  name                    = ""
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  public_ip_address_ids   = [azurerm_public_ip.pip001.id]
  public_ip_prefix_ids    = [azurerm_public_ip_prefix.pre001.id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

# Databricks Public NSG
resource "azurerm_network_security_group" "nsg001" {
  name                = ""
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Databricks Private NSG
resource "azurerm_network_security_group" "nsg002" {
  name                = ""
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Databricks Workspace
resource "azurerm_databricks_workspace" "dw001" {
  name                = ""
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = ""
    public_subnet_network_security_group_association_id = ""
    private_subnet_name = ""
    private_subnet_network_security_group_association_id = ""
    virtual_network_id  = ""
  }
}
