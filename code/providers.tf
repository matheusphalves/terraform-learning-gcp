terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_key_file_path)
  project     = var.gcp_project_id
  region      = var.gcp_region
}