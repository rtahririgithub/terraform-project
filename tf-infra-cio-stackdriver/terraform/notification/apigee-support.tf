locals {
  apigee_email_display_name = format("Apigee_Support-%s Email", upper(var.env))
}

variable "apigee_enable_notification" {
  type    = string
  default = ""
}

variable "apigee_support_email" {
  type    = string
  default = ""
}

module "apigee_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.apigee_email_display_name
  email_address = var.apigee_support_email
  enabled       = var.apigee_enable_notification
}
