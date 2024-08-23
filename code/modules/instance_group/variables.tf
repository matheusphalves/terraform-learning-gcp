variable "instance_group_network_id" {
  type = string
}

variable "instance_group_name" {
  type = string
}

variable "template_instance_self_link_unique" {
  type = string
}

variable "instance_group_region" {
  type = string
}

variable "distribution_policy_zones" {
  type = list(string)
}

variable "instance_base_name" {
  type = string
}

variable "target_size" {
  type = number
}