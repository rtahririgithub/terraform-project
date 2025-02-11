module "datahub-ws-csebi-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace CSE BI Support"
  type          = "email"
  email_address = "DLCSEBI-GCPWorkspace@telus.com"
  enabled       = var.enable_csebi_notification
}

variable "enable_csebi_notification" {
  description = "Boolean to control csebi billing notification"
  type        = string
  default     = "true"
}
