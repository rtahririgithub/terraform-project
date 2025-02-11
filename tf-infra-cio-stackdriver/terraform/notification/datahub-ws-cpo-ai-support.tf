module "datahub-ws-cpo-ai-support-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace CPO AI Support"
  type          = "email"
  email_address = "dlcpo_pace@telus.com"
  enabled       = var.enable_cpo_ai_support
}

variable "enable_cpo_ai_support" {
  description = "Boolean to control CPO AI notification"
  type        = string
  default     = "true"
}


