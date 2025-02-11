## storage bucket for cache
module "tf_cache_bucket" {
  source                = "git::ssh://git@github.com/telus/tf-module-gcp-storage?ref=v0.3.0%2Btf.0.13.3"
  project_id            = var.project_id
  bucket_name           = "tf-cache-${var.project_id}"
  versioning_enabled    = false
  force_destroy_enabled = false
  storage_class         = "REGIONAL"
  # lifecycle_type can be "Delete" or "SetStorageClass"
  lifecycle_type   = "Delete"
  lifecycle_params = { "storage" = "REGIONAL", "delete_days" = "30" }
}
