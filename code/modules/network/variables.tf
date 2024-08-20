variable "project_id" {
  type = string
  description = "Define the current project ID"
}

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
    name = string
    protocol = string
    ports    = list(string)
    target_tags = list(string)
    source_tags = list(string)
    source_ranges = list(string)
  }))
}