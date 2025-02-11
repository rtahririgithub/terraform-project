variable "cto_opus_reco_support_email" {
  type    = string
  default = ""
}

variable "cto_opus_reco_enable_notification" {
  type    = string
  default = ""
}

module "cto_opus_reco_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "Recognition support E-mail"
  type          = "email"
  email_address = var.cto_opus_reco_support_email
  enabled       = var.cto_opus_reco_enable_notification
}
