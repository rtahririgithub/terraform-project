variable "toutv_support_email" {
  type    = string
  default = ""
}

variable "toutv_enable_notification" {
  type    = string
  default = ""
}

module "toutv_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TouTv Support"
  type          = "email"
  email_address = var.toutv_support_email
  enabled       = var.toutv_enable_notification
}
