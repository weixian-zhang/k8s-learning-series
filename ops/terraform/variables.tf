
variable "location" {
    default = "southeastasia"
}

variable "resource_group_name" {
    default = "rg-k8s-learning"
}

variable "terr_state_backend_storage_name" {
    default = "strgk8slearning"
}  

variable "log_analystics_workspace_name" {
  default = "law-k8s-learning"
}

variable "container_registry_name" {
  default = "acrappsaks"
}

variable "subnet_id" {}

variable "container_registry_id" {}

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