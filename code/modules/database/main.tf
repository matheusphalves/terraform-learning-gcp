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
    }
  }
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "user" {
  instance = google_sql_database_instance.instance.name
  name     = local.db_username
  host     = "%"
  password = local.db_password
}