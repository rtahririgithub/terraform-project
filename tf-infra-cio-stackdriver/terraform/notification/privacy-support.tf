locals {
  privacy_display_name  = format("ECP Privacy Channel-%s Viewer", upper(var.env))
  privacy_email_address = format("ECP-GCP-IAM-%s-Viewer@telus.com", upper(var.env))
}


module "privacy_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = local.privacy_display_name
  type          = "email"
  email_address = local.privacy_email_address
  enabled       = var.enable_notification
}
