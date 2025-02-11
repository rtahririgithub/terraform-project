variable "wnp_support_email" {
  type    = string
  default = ""
}

variable "wnp_enable_notification" {
  type    = string
  default = false
}

module "wnp_notification_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "WNP Support Channel"
  type          = "email"
  email_address = var.wnp_support_email
  enabled       = var.wnp_enable_notification
} 