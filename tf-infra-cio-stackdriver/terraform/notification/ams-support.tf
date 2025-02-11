variable "ams_support_email" {
  type    = string
  default = ""
}

variable "ams_enable_notification" {
  type    = string
  default = ""
}

module "ams_support_channel" {
  count         = var.env == "np" ? 1 : 0
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "AMS Support"
  type          = "email"
  email_address = var.ams_support_email
  enabled       = var.ams_enable_notification
}