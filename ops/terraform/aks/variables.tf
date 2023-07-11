variable "resource_group_name" {
  default = "rg-k8s-learning"
}

variable "location" {}

variable "aks_aad_admin_group" {
  default = "wxz-k8s-admin"
}

variable "aks_name" {
  default = "aks-apps"
}
  
variable "aks_version" {
  default = "1.27.1"
}

variable "workload_identity_service_account_name" {
  default = "serviceaccount-az-workloadidentity-federated-mi"
}

variable "aks_uami_name" {
  default = "uami-aks-apps-agent"
}

variable "subnet_id" {}

variable "log_analystics_workspace_id" {}

variable "container_registry_id" {}

variable "private_cluster_enabled" {
  default = false
}

variable "system_node_pool" {
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    labels                         = map(string)
    # taints                         = list(string)
    enable_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  })
}

variable "user_node_pools" {
  description = "The map object to configure one or several additional node pools with number of worker nodes, worker node VM size and Availability Zones."
  type = list(object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    labels                         = map(string)
    # taints                         = list(string)
    os_sku                        = string
    enable_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  }))
}