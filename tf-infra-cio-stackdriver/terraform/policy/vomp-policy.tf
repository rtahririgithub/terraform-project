variable "vomp_project_id" {
  type = string
}

variable "vomp_enable_alert" {
  type = string
}

variable "vomp_enable_error_notification" {
  type = string
}

locals {
  # vomp_ui_uptime_check_id         = data.terraform_remote_state.uptime.outputs.vomp_ui_uptime_check.uptime_check_id[0] 
  # vomp_be_uptime_check_id         = data.terraform_remote_state.uptime.outputs.vomp_be_uptime_check.uptime_check_id[0]
  # vomp_aizan_uptime_check_id      = data.terraform_remote_state.uptime.outputs.vomp_aizan_uptime_check.uptime_check_id[0]
  # vomp_lsr_uptime_check_id        = data.terraform_remote_state.uptime.outputs.vomp_lsr_uptime_check.uptime_check_id[0]
  # vomp_system_api_uptime_check_id = data.terraform_remote_state.uptime.outputs.vomp_system_api_uptime_check.uptime_check_id[0]
  # vomp_task_flow_uptime_check_id  = data.terraform_remote_state.uptime.outputs.vomp_task_flow_uptime_check.uptime_check_id[0]
  vomp_ui_uptime_check_id         = "fixme"
  vomp_be_uptime_check_id         = "fixme"
  vomp_aizan_uptime_check_id      = "fixme"
  vomp_lsr_uptime_check_id        = "fixme"
  vomp_system_api_uptime_check_id = "fixme"
  vomp_task_flow_uptime_check_id  = "fixme"


  vomp_monitored_project_id = var.vomp_project_id
}

data "google_monitoring_notification_channel" "vomp_support" {
  display_name = "VOMP Support"
  project      = var.project_id
}

module "vomp_ui_uptime_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "VOMP Frontend - Offline (${var.env})"
  condition_display_name = "VOMP Frontend - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.vomp_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.vomp_ui_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.vomp_enable_alert
  content                = templatefile("${path.module}/vomp-policy.md", { project_id = local.vomp_monitored_project_id })
}

module "vomp_be_uptime_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "VOMP Backend - Offline (${var.env})"
  condition_display_name = "VOMP Backend - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.vomp_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.vomp_be_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.vomp_enable_alert
  content                = templatefile("${path.module}/vomp-policy.md", { project_id = local.vomp_monitored_project_id })
}

module "vomp_aizan_uptime_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "VOMP Aizan wrapper - Offline (${var.env})"
  condition_display_name = "VOMP Aizan wrapper - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.vomp_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.vomp_aizan_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.vomp_enable_alert
  content                = templatefile("${path.module}/vomp-policy.md", { project_id = local.vomp_monitored_project_id })
}

module "vomp_lsr_uptime_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "VOMP LSR wrapper - Offline (${var.env})"
  condition_display_name = "VOMP LSR wrapper - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.vomp_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.vomp_lsr_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.vomp_enable_alert
  content                = templatefile("${path.module}/vomp-policy.md", { project_id = local.vomp_monitored_project_id })
}

module "vomp_system_api_uptime_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "VOMP System API - Offline (${var.env})"
  condition_display_name = "VOMP System API - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.vomp_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.vomp_system_api_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.vomp_enable_alert
  content                = templatefile("${path.module}/vomp-policy.md", { project_id = local.vomp_monitored_project_id })
}

module "vomp_task_flow_uptime_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "VOMP Task flow - Offline (${var.env})"
  condition_display_name = "VOMP Task flow - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.vomp_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.vomp_task_flow_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.vomp_enable_alert
  content                = templatefile("${path.module}/vomp-policy.md", { project_id = local.vomp_monitored_project_id })
}

# All pods 'Error' and 'Exception' in logs alert
module "vomp_severity_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "VOMP Severity Errors"
  condition_display_name = "VOMP Severity Errors"
  notif_id               = [data.google_monitoring_notification_channel.vomp_support.name]
  content                = templatefile("${path.module}/vomp-error-policy.md", { project_id = local.vomp_monitored_project_id })
  filter                 = "metric.type=\"logging.googleapis.com/user/vomp/severity_error_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.vomp_enable_error_notification
}

module "vomp_level_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "VOMP Level Errors"
  condition_display_name = "VOMP Level Errors"
  notif_id               = [data.google_monitoring_notification_channel.vomp_support.name]
  content                = templatefile("${path.module}/vomp-error-policy.md", { project_id = local.vomp_monitored_project_id })
  filter                 = "metric.type=\"logging.googleapis.com/user/vomp/level_error_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.vomp_enable_error_notification
}