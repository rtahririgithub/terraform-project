variable "mtelus_support_email" {
  type    = string
  default = ""
}

variable "mtelus_enable_notification" {
  type    = string
  default = ""
}

module "mtelus_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "MTelus Support"
  type          = "email"
  email_address = var.mtelus_support_email
  enabled       = var.mtelus_enable_notification
}
