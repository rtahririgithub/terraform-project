module "smart_ivr_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Smart IVR Support"
  type          = "email"
  email_address = "dlsmart-ivr@telus.com"
  enabled       = var.enable_notification
}