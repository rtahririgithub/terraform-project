locals {
  mediation-whsia-tmf635_email_display_name = format("Mediation-WHSIA-TMF635_GCP_Support-%s Email", upper(var.env))
  mediation-whsia-tmf635_personal_name      = format("Mediation-WHSIA-TMF635_Personal-Support-%s Email", upper(var.env))
}

variable "mediation-whsia-tmf635_enable_notification" {
  type    = string
  default = false
}

variable "mediation-whsia-tmf635_support_email" {
  type    = string
  default = ""
}

variable "mediation-whsia-tmf635-personal_enable_notification" {
  type    = string
  default = true
}

module "mediation-whsia-tmf635_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.mediation-whsia-tmf635_email_display_name
  email_address = var.mediation-whsia-tmf635_support_email
  enabled       = var.mediation-whsia-tmf635_enable_notification
}

module "mediation-whsia-tmf635_support_personal_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.mediation-whsia-tmf635_personal_name
  email_address = "macsym.wang@telus.com"
  enabled       = var.mediation-whsia-tmf635-personal_enable_notification
}