variable "tpsbooking_support_email" {
  type = string
}

variable "tpsbooking_enable_notification" {
  type = string
}

module "tpsbooking_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TPS Booking Support"
  type          = "email"
  email_address = var.tpsbooking_support_email
  enabled       = var.tpsbooking_enable_notification
}



