resource "google_compute_region_instance_group_manager" "webserver_instance_group" {
  name = var.instance_group_name

  base_instance_name        = var.instance_base_name
  region                    = var.instance_group_region
  distribution_policy_zones = var.distribution_policy_zones
  target_size               = var.target_size

  version {
    instance_template = var.template_instance_self_link_unique
  }

  named_port {
    name = "http"
    port = 80
  }
}