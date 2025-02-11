locals {
  opus_squad3_email_display_name = format("Google Cloud Alerting-%s Opus-Squad3 Email", upper(var.env))
}

variable "opus_squad3_enable_notification" {
  type    = string
  default = ""
}

variable "opus_squad3_support_email" {
  type    = string
  default = ""
}

module "opus_squad3_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  type          = "email"
  project_id    = var.project_id
  display_name  = local.opus_squad3_email_display_name
  email_address = var.opus_squad3_support_email
  enabled       = var.opus_squad3_enable_notification
}
