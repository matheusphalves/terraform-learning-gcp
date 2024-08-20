output "vpc_id" {
  value = google_compute_network.vpc_network.id
}

output "subnetworks_id" {
  value = local.first_private_subnetwork_id
}
