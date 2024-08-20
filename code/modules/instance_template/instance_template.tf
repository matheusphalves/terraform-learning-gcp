resource "google_service_account" "webserver_service_account" {
  account_id   = "${var.template_name}-service-account"
  display_name = "${upper(var.template_name)} Service Account"
  description  = "Service Account created by Terraform"
  project      = var.project_id
}

resource "google_compute_instance_template" "server_template" {
  name         = var.template_name
  machine_type = var.machine_type

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnetwork_id
    // No public IP address available
  }

  metadata = {
    "startup-script-url" = var.startup_script_url
  }

  tags = ["web-servers"]

  disk {
    auto_delete  = true
    boot         = true
    device_name  = "${var.template_name}-disk"
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240815"
    type         = "pd-balanced"
  }

  shielded_instance_config {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = google_service_account.webserver_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_storage_bucket_iam_member" "bucket_access" {
  bucket = var.setup_bucket
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.webserver_service_account.email}"
}
