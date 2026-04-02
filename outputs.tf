output "web_app_name" {
  value = azurerm_web_app.web_app.name
}

output "app_service_name" {
  value = azurerm_web_app.app_service.name
}

output "sql_server_name" {
  value = azurerm_sql_server.db_server.name
}

output "sql_db_name" {
  value = azurerm_sql_database.db.name
}

output "sql_admin_user" {
  value = var.sql_admin_user
}

output "sql_admin_password" {
  value = var.sql_admin_password
}