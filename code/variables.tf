variable "gcp_key_file_path" {
  type = string
  description = "Path to your GCP service account key JSON file"
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "template_name" {
  type = string
}