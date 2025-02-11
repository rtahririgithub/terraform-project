module "uom_api_notification_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Unified Offer Manager - API Notification Channel"
  type          = "email"
  email_address = "dltomapi@telus.com"
  enabled       = var.enable_notification
}
