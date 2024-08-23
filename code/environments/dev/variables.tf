variable "gcp_region" {
  type        = string
  description = "Default region used to create the resources."
}

variable "gcp_key_file_path" {
  type        = string
  description = "Path to your GCP service account key JSON file."
}

variable "gcp_project_id" {
  type        = string
  description = "Current GCP Project used to apply changes."
}

# Bucket
variable "bucket_name" {
  type = string
}

variable "bucket_object_source_directory" {
  type = string
}

# Network
variable "vpc_name" {
  type = string
}

variable "subnetwork_configs" {
  type = map(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
}

variable "firewall_rule_mapping" {
  type = map(object({
    name          = string
    protocol      = string
    ports         = list(string)
    target_tags   = list(string)
    source_ranges = list(string)
  }))
}

# Template instance
variable "machine_type" {
  type = string
}

variable "template_name" {
  type = string
}

variable "tags" {
  type = string
}

# Instance Group
variable "instance_group_name" {
  type = string
}

variable "instance_group_region" {
  type = string
}

variable "instance_base_name" {
  type = string
}

variable "target_size" {
  type = number
}

# Database
variable "database_name" {
  type = string
}

variable "database_instance_name" {
  type = string
}

variable "database_instance_region" {
  type = string
}

# Load Balancer
variable "backend_service_name" {
  type = string
}

variable "http_health_check_name" {
  type = string
}

variable "http_health_check_port" {
  type = number
}

variable "load_balancer_name" {
  type = string
}

variable "network_ip_cidr_range" {
  type = string
}