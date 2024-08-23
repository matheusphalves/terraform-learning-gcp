output "available_zones" {
  description = "List of available zones in the specified region"
  value       = data.google_compute_zones.available_zones.names
}