locals {
  dfcx_email_display_name = format("DFCX_Support-%s Email", upper(var.env))
}

variable "dfcx_enable_notification" {
  type    = string
  default = ""
}

variable "dfcx_support_email" {
  type    = string
  default = ""
}

module "dfcx_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.dfcx_email_display_name
  email_address = var.dfcx_support_email
  enabled       = var.dfcx_enable_notification
}
