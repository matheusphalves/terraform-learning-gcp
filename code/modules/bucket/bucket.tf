resource "google_storage_bucket" "app_bucket" {
  name                     = var.bucket_name
  location                 = var.bucket_location
  force_destroy            = true
  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "my_objects" {

  for_each = {
    "setup.sh" = {
      content_type = "txt/sh"
      source       = "${var.bucket_object_source_directory}/setup.sh"
    },
    "app_demo.jar" = {
      content_type = "application/java-archive"
      source       = "${var.bucket_object_source_directory}/hello_app.jar"
    },
  }

  bucket       = google_storage_bucket.app_bucket.name
  name         = each.key
  source       = each.value.source
  content_type = each.value.content_type
}
