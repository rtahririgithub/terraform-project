variable "ecpslack_support_email" {
  type    = string
  default = ""
}

variable "ecpslack_enable_notification" {
  type    = string
  default = false
}

module "ecpslack_notification_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "ECP Slack Email"
  type          = "email"
  email_address = var.ecpslack_support_email
  enabled       = var.ecpslack_enable_notification
} 