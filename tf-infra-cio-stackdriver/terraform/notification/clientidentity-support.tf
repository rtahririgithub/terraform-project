locals {
  clientidentity_email_display_name = "Clientidentity Notification Channel"
}

variable "clientidentity_enable_notification" {
  type = string
}

variable "clientidentity_support_email" {
  type = string
}

module "clientidentity_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.clientidentity_email_display_name
  email_address = var.clientidentity_support_email
  enabled       = var.clientidentity_enable_notification
}
