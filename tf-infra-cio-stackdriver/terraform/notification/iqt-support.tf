variable "iqt_support_email" {
  type    = string
  default = ""
}

variable "iqt_enable_notification" {
  type    = string
  default = ""
}

module "iqt_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "IQT Support"
  type          = "email"
  email_address = var.iqt_support_email
  enabled       = var.iqt_enable_notification
}
