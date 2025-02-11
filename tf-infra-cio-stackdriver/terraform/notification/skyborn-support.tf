variable "skyborn_support_email" {}

variable "skyborn_enable_notification" {}

module "skyborn_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Skyborn Support"
  type          = "email"
  email_address = var.skyborn_support_email
  enabled       = var.skyborn_enable_notification
}