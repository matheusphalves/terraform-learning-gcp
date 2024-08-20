locals {
  private_subnetwork_keys = keys(google_compute_subnetwork.private_subnetworks)

  private_first_subnetwork_key = tolist(local.private_subnetwork_keys)[0]
  
  first_private_subnetwork_region = google_compute_subnetwork.private_subnetworks[local.private_first_subnetwork_key].region
  first_private_subnetwork_id = google_compute_subnetwork.private_subnetworks[local.private_first_subnetwork_key].id
}