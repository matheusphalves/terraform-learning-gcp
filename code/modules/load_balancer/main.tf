resource "google_compute_backend_service" "backend_service" {
  name                  = var.backend_service_name
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  enable_cdn            = false
  health_checks         = [google_compute_health_check.http_health_check.id]
  backend {
    group           = var.webserver_instance_group_self_link
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }
}

resource "google_compute_health_check" "http_health_check" {
  name                = "health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port = var.http_health_check_port
  }
}

resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "${var.load_balancer_name}-target-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.load_balancer_name}-url-map"
  default_service = google_compute_backend_service.backend_service.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "${var.load_balancer_name}-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.target_http_proxy.id
  ip_address            = google_compute_global_address.global_address.address
}

resource "google_compute_global_address" "global_address" {
  name = "${var.load_balancer_name}-global-address"
}
