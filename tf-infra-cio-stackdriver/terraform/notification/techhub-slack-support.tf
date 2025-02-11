locals {
  techhub_slack_display_name = format("Google Cloud Alerting-%s TechHub UI Slack", upper(var.env))
}

variable "techhub_notification_slack_channel_name" {
  type = string
}
variable "techhub_enable_notification_slack" {
  type = string
}
data "google_secret_manager_secret_version" "techhub_ui_slack_secret" {
  project = var.project_id
  secret  = "techhub_ui_slack_secret"
}

resource "google_monitoring_notification_channel" "techhub_notification_slack_channel" {
  display_name = local.techhub_slack_display_name
  type         = "slack"
  project      = var.project_id
  labels = {
    "channel_name" = var.techhub_notification_slack_channel_name
  }
  sensitive_labels {
    auth_token = data.google_secret_manager_secret_version.techhub_ui_slack_secret.secret_data
  }
  enabled = var.techhub_enable_notification_slack
}
