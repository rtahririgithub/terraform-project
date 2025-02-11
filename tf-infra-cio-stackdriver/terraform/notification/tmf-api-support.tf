variable "tmf_enable_notification" {
  type    = string
  default = "true"
}

variable "tmf_project_id" {
  type    = string
  default = "cdo-recommendation-mgmt-np-7c"
}

module "tmf_api_notification_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TMF Support"
  type          = "email"
  email_address = "sudheer.aki@telus.com"
  enabled       = var.enable_notification
}


module "tmf_api_notification_channel_team" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TMS Team"
  type          = "email"
  email_address = "dlNBA-Agile@telus.com"
  enabled       = var.enable_notification
}


module "tmf_pubsub_notification_channel" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id   = var.project_id
  display_name = "TMF Pubsub Support"
  type         = "pubsub"
  pubsub_topic = "projects/${var.tmf_project_id}/topics/recommendation-mgmt-${var.env}"
  enabled      = var.tmf_enable_notification
}