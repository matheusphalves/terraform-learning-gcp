resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "private_subnetworks" {

  network  = google_compute_network.vpc_network.id
  for_each = var.subnetwork_configs

  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
}

resource "google_compute_firewall" "allow_firewall_rules" {

  for_each = var.firewall_rule_mapping

  name    = each.value.name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

   source_tags = each.value.source_tags
   source_ranges = each.value.source_ranges
   target_tags = each.value.target_tags
}
