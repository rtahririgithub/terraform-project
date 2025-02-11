variable "datahub_support_email" {
  type = string
}

variable "datahub_enable_notification" {
  type = string
}

module "datahub_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "Datahub Support E-mail"
  email_address = var.datahub_support_email
  enabled       = var.datahub_enable_notification
}

module "datahub_infra_supp_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "Datahub Infrastructure Support E-mail"
  email_address = "dlGCP_Datahub_Infra_Support@telus.com"
  enabled       = var.datahub_enable_notification
}