output "client_certificate" {
    description = "Client certificate for the AKS cluster"
    value       = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
    sensitive   = true
  
}

output "kube_config" {
    description = "Kube config for the AKS cluster"
    value       = azurerm_kubernetes_cluster.aks_cluster.kube_config
    sensitive   = true
  
}