module "uom_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Uom Support"
  type          = "email"
  email_address = "dlTOMGUI@telus.com"
  enabled       = var.enable_notification
}