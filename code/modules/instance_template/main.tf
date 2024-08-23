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

  tags = [var.tags]

  disk {
    auto_delete  = true
    boot         = true
    device_name  = "${var.template_name}-disk"
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240815"
    type         = "PERSISTENT"
  }

  shielded_instance_config {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}