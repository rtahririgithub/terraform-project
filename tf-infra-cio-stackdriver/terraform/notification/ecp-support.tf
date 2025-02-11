variable "ecp_support_email_list" {
  type    = map(string)
  default = {}
}

variable "ecp_enable_notification" {
  type    = string
  default = ""
}

module "ecp_email_support_channels" {
  for_each      = var.ecp_support_email_list
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = each.key
  type          = "email"
  email_address = each.value
  enabled       = var.ecp_enable_notification
}
