# Yaraworks support Notification Email

variable "yw_support_email" {
  type    = string
  default = ""
}

variable "yw_enable_notification" {
  type    = string
  default = ""
}

module "yw_etl_notification" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "Yaraworks Support"
  email_address = var.yw_support_email
  enabled       = var.yw_enable_notification
}
