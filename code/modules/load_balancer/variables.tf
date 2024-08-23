variable "backend_service_name" {
  type = string
}

variable "http_health_check_name" {
  type = string
}

variable "http_health_check_port" {
  type = number
}

variable "webserver_instance_group_self_link" {
  type = string
}

variable "load_balancer_name" {
  type = string
}

variable "network_id" {
  type = string
}

variable "network_region" {
  type = string
}

variable "network_ip_cidr_range" {
  type = string
}