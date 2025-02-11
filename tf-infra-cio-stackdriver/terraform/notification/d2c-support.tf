module "d2c_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "D2C Support"
  type          = "email"
  email_address = "dlD2C-DevSupport@telus.com"
  enabled       = var.enable_notification
}