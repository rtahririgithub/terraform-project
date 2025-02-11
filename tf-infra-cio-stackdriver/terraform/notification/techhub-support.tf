variable "techhub_support_email" {}

variable "techhub_enable_notification" {}

module "techhub_notification_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TechHub Notification Channel"
  type          = "email"
  email_address = var.techhub_support_email
  enabled       = var.techhub_enable_notification
}
