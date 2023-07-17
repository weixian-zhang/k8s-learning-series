
data "azuread_group" "aks_aad_admin_group" {
  display_name = var.aks_aad_admin_group
}

resource "azurerm_user_assigned_identity" "aks_uami" {
  location            = var.location
  name                = var.aks_uami_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "aks" {

  name                            = var.aks_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  dns_prefix                      = var.aks_name
  kubernetes_version              = var.aks_version
  node_resource_group             = var.resource_group_name
  private_cluster_enabled         = var.private_cluster_enabled
  sku_tier                        = "Standard"
  workload_identity_enabled       = true
  oidc_issuer_enabled             = true


  default_node_pool {
    name                  = substr(var.system_node_pool.name, 0, 12)
    orchestrator_version  = var.aks_version
    node_count            = var.system_node_pool.node_count
    vm_size               = var.system_node_pool.vm_size
    type                  = "VirtualMachineScaleSets"
    zones                 = var.system_node_pool.zones
    max_pods              = 250
    os_disk_size_gb       = 128
    vnet_subnet_id        = var.subnet_id
    node_labels           = var.system_node_pool.labels
    enable_auto_scaling   = var.system_node_pool.enable_auto_scaling
    min_count             = var.system_node_pool.cluster_auto_scaling_min_count
    max_count             = var.system_node_pool.cluster_auto_scaling_max_count
    enable_node_public_ip = false
    
  }

  identity {
    type = "SystemAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_uami.id]
  }

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = [
        data.azuread_group.aks_aad_admin_group.id
    ]
  }

#   addon_profile {
#     oms_agent {
#       enabled                    = var.addons.oms_agent
#       log_analytics_workspace_id = var.log_analytics_workspace_id
#     }
#     kube_dashboard {
#       enabled = var.addons.kubernetes_dashboard
#     }
#     azure_policy {
#       enabled = var.addons.azure_policy
#     }
#   }

  network_profile {
    load_balancer_sku  = "standard"
    outbound_type      = "managedNATGateway"
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
  
  for_each = { for k, v in var.user_node_pools: k => v }
  name = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size = each.value.vm_size
  node_count = each.value.node_count
  zones = each.value.zones
  os_sku = each.value.os_sku
  enable_auto_scaling = each.value.enable_auto_scaling
  max_count = each.value.cluster_auto_scaling_max_count
  min_count = each.value.cluster_auto_scaling_min_count
  node_labels = each.value.labels
}

# aks uses this user assgined managed identity to manage cluster and dependent azure resources
resource "azurerm_role_assignment" "aks_uami_role_assign" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.container_registry_id
  skip_service_principal_aad_check = true
}

# Workload identity - UAMI federation trust
resource "azurerm_federated_identity_credential" "this" {
  name                = local.workload_identity_service_account_namespace
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_uami.id
  subject             = "system:serviceaccount:${local.workload_identity_service_account_namespace}:${var.workload_identity_service_account_name}"
}