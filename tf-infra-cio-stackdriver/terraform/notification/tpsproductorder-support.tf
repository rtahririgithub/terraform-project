variable "tpsproductorder_support_email" {
  type = string
}

variable "tpsproductorder_enable_notification" {
  type = string
}

module "tpsproductorder_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TPS API Support"
  type          = "email"
  email_address = var.tpsproductorder_support_email
  enabled       = var.tpsproductorder_enable_notification
}
