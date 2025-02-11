module "datahub-ws-reliab-support-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace Reliability Support"
  type          = "email"
  email_address = "dlSelectStars@telus.com"
  enabled       = var.enable_reliab_support
}

variable "enable_reliab_support" {
  description = "Boolean to control Reliability notification"
  type        = string
  default     = "true"
}
