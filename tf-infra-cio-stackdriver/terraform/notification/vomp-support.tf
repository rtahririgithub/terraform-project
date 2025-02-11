variable "vomp_support_email" {
  type = string
}

variable "vomp_enable_notification" {
  type = string
}

module "vomp_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "VOMP Support"
  type          = "email"
  email_address = var.vomp_support_email
  enabled       = var.vomp_enable_notification
}
