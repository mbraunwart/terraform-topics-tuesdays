output "app_service_address" {
  value       = "https://${azurerm_linux_web_app.web.default_hostname}"
  description = "HTTPS address of linx web app."
}
