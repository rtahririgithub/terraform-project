locals {
  mediation-b2b_email_display_name = format("Mediation-B2B_GCP_Support-%s Email", upper(var.env))
  mediation-b2b_personal_name      = format("Mediation-Personal-Support-%s Email", upper(var.env))
  mediation-mz_email_display_name  = format("Mediation-MZ-Support-%s Email", upper(var.env))

}

variable "mediation-mz_enable_notification" {
  type    = string
  default = false
}

variable "mediation-b2b_enable_notification" {
  type    = string
  default = false
}

variable "mediation-mz_support_email" {
  type    = string
  default = ""
}

variable "mediation-b2b_support_email" {
  type    = string
  default = ""
}

module "mediation-b2b_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.mediation-b2b_email_display_name
  email_address = var.mediation-b2b_support_email
  enabled       = var.mediation-b2b_enable_notification
}

module "mediation-mz_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.mediation-mz_email_display_name
  email_address = var.mediation-mz_support_email
  enabled       = var.mediation-mz_enable_notification
}

module "mediation-b2b_support_personal_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.mediation-b2b_personal_name
  email_address = "jose.arias@telus.com"
  enabled       = var.mediation-b2b_enable_notification
}
