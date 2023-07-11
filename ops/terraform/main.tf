
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.64.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-k8s-learning"
    storage_account_name = "strgk8slearning"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_account" "storage" {
  name = var.terr_state_backend_storage_name
  location = var.location
  resource_group_name = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"  
  enable_https_traffic_only = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_log_analytics_workspace" "law" {
  name = var.log_analystics_workspace_name
  resource_group_name = var.resource_group_name
  location = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name 
  location            = var.location
  sku                 = "Premium"
}

module "aks" {
  source = "./aks"
  location = var.location
  subnet_id = var.subnet_id
  log_analystics_workspace_id = azurerm_log_analytics_workspace.law.id
  container_registry_id = var.container_registry_id
  system_node_pool = var.system_node_pool
  user_node_pools = var.user_node_pools
}