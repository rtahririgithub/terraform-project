variable "equip_inventory_enable_notification" {
  type = bool
}

variable "equip_inventory_support_email" {
  type = string
}

module "equip_inventory_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id    = var.project_id
  display_name  = "dl Sharks Support"
  email_address = var.equip_inventory_support_email
  enabled       = var.equip_inventory_enable_notification
}

module "equip_inventory_dev_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id    = var.project_id
  display_name  = "GM Dev Support"
  email_address = "marian.puscasu@telus.com"
  enabled       = true
}
