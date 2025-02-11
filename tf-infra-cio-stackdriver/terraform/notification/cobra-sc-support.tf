variable "cobra-sc_support_email" {
  type    = string
  default = ""
}

variable "cobra-sc_enable_notification" {
  type    = string
  default = false
}

module "cobra-sc_notification_channel" {
  count         = var.env == "np" ? 1 : 0
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "COBRA Surcharge Calculator Support Channel"
  type          = "email"
  email_address = var.cobra-sc_support_email
  enabled       = var.cobra-sc_enable_notification
}