resource "random_password" "user" {
  length  = 10
  special = true
}

resource "random_string" "db_username" {
  length  = 12
  special = false
  lower   = true
}

resource "google_secret_manager_secret" "db_user_secret" {
  secret_id = "DB_USER"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_user_version" {
  secret      = google_secret_manager_secret.db_user_secret.id
  secret_data = local.db_username
}


resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = "DB_PASSWORD"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = local.db_password
}