variable "techhub_project_id" {
  type = string
}

variable "techhub_enable_notification" {
  type = bool
}

variable "techhub_dv_uptime_check_id" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type = string
}

variable "techhub_ui_slack_alert_threshold" {
  type = string
}

locals {
  techhub_uptime_check_id = data.terraform_remote_state.uptime.outputs.techhub_uptime_check.uptime_check_id[0]
  #techhub_dv_uptime_check_id = data.terraform_remote_state.uptime.outputs.techhub_dv_uptime_check.uptime_check_id[0]
  techhub_dv_uptime_check_id = var.techhub_dv_uptime_check_id
  content                    = file("${path.module}/techhub-policy.md")
}

data "google_monitoring_notification_channel" "techhub_support" {
  display_name = "TechHub Notification Channel"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "techhub_support_slack" {
  display_name = "Google Cloud Alerting-${upper(var.env)} TechHub UI Slack"
  project      = var.project_id
}


module "techhub_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Techhub UI] [${upper(var.env)}] Https URL Alert policy"
  condition_display_name = "[Techhub UI] [${upper(var.env)}] - Https URL Alert policy"
  notif_id               = [data.google_monitoring_notification_channel.techhub_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.techhub_uptime_check_id}\""
  enabled                = var.techhub_enable_notification
  content                = local.content
}

module "techhub_dv_alert_policy" {
  # only for stackdriver nonprod for techhub-dv
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Techhub UI] [DV] Https URL Alert policy"
  condition_display_name = "[Techhub UI] [DV] - Https URL Alert policy"
  notif_id               = [data.google_monitoring_notification_channel.techhub_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.techhub_dv_uptime_check_id}\""
  enabled                = var.techhub_enable_notification
  content                = local.content
}

module "techhub_error_alert_policy_slack" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Techhub UI] [${upper(var.env)}] UI Error Alert policy"
  condition_display_name = "[Techhub UI] [${upper(var.env)}] - UI Error Alert policy"
  notif_id               = [data.google_monitoring_notification_channel.techhub_support_slack.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/${var.cluster_name}/techhub_ui_error\" resource.type=\"k8s_container\""
  group_by_fields        = ["metric.TechHubNotificationError"]
  threshold_value        = var.techhub_ui_slack_alert_threshold
  duration               = "0s"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_SUM"
  enabled                = var.techhub_enable_notification
}
