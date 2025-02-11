locals {
  bpr_email_display_name = format("Bill Presentment Notification-%s Email", upper(var.env))
}

variable "bpr_enable_notification" {
  type = string
}

variable "bpr_support_email" {
  type = string
}

module "bpr_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.bpr_email_display_name
  email_address = var.bpr_support_email
  enabled       = var.bpr_enable_notification
}
