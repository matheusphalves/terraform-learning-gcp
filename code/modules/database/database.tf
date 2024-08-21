resource "google_sql_database_instance" "instance" {

  name                = var.database_instance_name
  region              = var.database_instance_region
  database_version    = var.database_instance_version
  deletion_protection = var.enable_deletion_protection

  settings {

    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.database_instance_network_id
      require_ssl     = false
    }
  }
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "user" {
  instance = google_sql_database_instance.instance.name
  name     = "user-spring"
  host     = "%"
  password = local.db_password
}

resource "random_password" "user" {
  length  = 10
  special = true
}

resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = "db-password"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = local.db_password
}

