variable "data_subset_enable_notification" {
  type    = bool
  default = true
}

variable "data_subset_support_email" {
  type    = string
  default = "ethan.johnson@telus.com"
}

module "data_subset_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id    = var.project_id
  display_name  = "Data Subset Email Support"
  email_address = var.data_subset_support_email
  enabled       = var.data_subset_enable_notification
}