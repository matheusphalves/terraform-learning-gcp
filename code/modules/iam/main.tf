resource "google_service_account" "webserver_service_account" {
  account_id   = var.account_id
  display_name = "${upper(var.account_id)} Service Account"
  description  = "Service Account created by Terraform"
  project      = var.project_id
}

resource "google_storage_bucket_iam_member" "bucket_access" {
  bucket = var.bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.webserver_service_account.email}"
}

resource "google_project_iam_member" "cloud_sql_access" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.webserver_service_account.email}"
}

resource "google_project_iam_member" "secretmanager_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.webserver_service_account.email}"
}