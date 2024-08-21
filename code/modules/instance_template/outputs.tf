output "instance_template_self_link_unique" {
  value = google_compute_instance_template.server_template.self_link_unique
}

output "server_service_account_email" {
  value = google_service_account.webserver_service_account.email
}