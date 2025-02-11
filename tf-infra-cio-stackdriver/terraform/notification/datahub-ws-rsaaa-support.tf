module "datahub-ws-rsaaa-support-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace RSAAA Support"
  type          = "email"
  email_address = "pavel.bondarev@telus.com"
  enabled       = var.enable_rsaaa_support
}

variable "enable_rsaaa_support" {
  description = "Boolean to control WSOC notification"
  type        = string
  default     = "true"
}
