locals {
  display_name  = format("ECP Notification Channel-%s Viewer", upper(var.env))
  email_address = format("ECP-GCP-IAM-%s-Viewer@telus.com", upper(var.env))
}


module "ecp_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = local.display_name
  type          = "email"
  email_address = local.email_address
  enabled       = var.enable_notification
} 