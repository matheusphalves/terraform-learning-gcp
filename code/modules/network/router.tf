resource "google_compute_router" "marketplace_router" {
  name    = "marketplace-router"
  region  = local.first_private_subnetwork_region
  network = google_compute_network.vpc_network.name
}

resource "google_compute_router_nat" "marketplace_external_nat" {
  name   = "external-marketplace-nat"
  router = google_compute_router.marketplace_router.name
  region = google_compute_router.marketplace_router.region

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.private_subnetworks
    content {
      name                    = subnetwork.value.name
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}
