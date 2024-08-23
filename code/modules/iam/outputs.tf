output "webserver_service_account" {
  value = {
    account_id = google_service_account.webserver_service_account.account_id
    email      = google_service_account.webserver_service_account.email
  }
}