output "webserver_instance_group_self_link" {
  value = google_compute_region_instance_group_manager.webserver_instance_group.instance_group
}