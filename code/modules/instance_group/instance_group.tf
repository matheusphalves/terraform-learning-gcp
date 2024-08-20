resource "google_compute_region_instance_group_manager" "webserver_instance_group" {
  name = var.instance_group_name

  base_instance_name        = var.instance_base_name
  region                    = var.instance_group_region
  distribution_policy_zones = ["us-west1-a", "us-west1-b"]

  version {
    instance_template = var.template_instance_self_link_unique
  }

  target_size = var.target_size
}
