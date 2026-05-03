output "container_app_url" {
  value = azurerm_container_app.container-app-deployment.latest_revision_fqdn
}

output "container_app_ip" {
  value = azurerm_container_app_environment.container-app-env.static_ip_address
}
