output "setup_sh_url" {
  value       = "gs://${google_storage_bucket.app_bucket.name}/setup.sh"
  description = "URL of the setup.sh object in the GCS bucket"
}

output "bucket_name" {
  value = google_storage_bucket.app_bucket.name
}