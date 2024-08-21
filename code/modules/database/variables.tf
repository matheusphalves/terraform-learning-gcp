variable "database_instance_name" {
  type = string
}

variable "database_instance_region" {
  type = string
}

variable "database_instance_network_id" {
  type = string
}

variable "database_instance_version" {
  type = string
  default = "MYSQL_8_0"
}

variable "enable_deletion_protection" {
  type = bool
  default = false
}

variable "database_name" {
  type = string
}

variable "server_service_account_email" {
  type = string
}