variable "equip_warranty_enable_notification" {
  type = bool
}

variable "equip_warranty_support_email" {
  type = string
}

module "equip_warranty_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id    = var.project_id
  display_name  = "dl Rhinos Support"
  email_address = var.equip_warranty_support_email
  enabled       = var.equip_warranty_enable_notification
}