variable "comm_nccs_trl_stmt_enable_notification" {
  type    = bool
  default = true
}

variable "comm_nccs_trl_stmt_support_email" {
  type    = string
  default = "stefan.stratulat@telus.com"
}

module "comm_nccs_trl_stmt_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id    = var.project_id
  display_name  = "Corporate Stores Commission Statements Email Support"
  email_address = var.comm_nccs_trl_stmt_support_email
  enabled       = var.comm_nccs_trl_stmt_enable_notification
}