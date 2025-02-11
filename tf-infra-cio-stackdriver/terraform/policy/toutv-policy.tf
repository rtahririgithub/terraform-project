variable "toutv_enable_alert" {
  description = "enable the alert"
  type        = string
  default     = false
}

variable "toutv_project_id" {
  type    = string
  default = ""
}

locals {
  toutv_ui_uptime_check_id       = data.terraform_remote_state.uptime.outputs.toutv_ui_uptime_check.uptime_check_id[0]
  toutv_be_uptime_check_id       = data.terraform_remote_state.uptime.outputs.toutv_be_uptime_check.uptime_check_id[0]
  toutv_admin_ui_uptime_check_id = data.terraform_remote_state.uptime.outputs.toutv_admin_ui_uptime_check.uptime_check_id[0]
  toutv_admin_be_uptime_check_id = data.terraform_remote_state.uptime.outputs.toutv_admin_be_uptime_check.uptime_check_id[0]
  toutv_premium_uptime_check_id  = data.terraform_remote_state.uptime.outputs.toutv_premium_uptime_check.uptime_check_id[0]
}

data "google_monitoring_notification_channel" "toutv_support" {
  display_name = "TouTv Support"
  project      = var.project_id
}

# Uptime alerts
module "toutv_ui_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TouTv UI - Offline (${var.env})"
  condition_display_name = "TouTv UI - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.toutv_support.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.toutv_ui_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.toutv_enable_alert
}

module "toutv_be_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TouTv Backend - Offline (${var.env})"
  condition_display_name = "TouTv Backend - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.toutv_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.toutv_be_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.toutv_enable_alert
}

module "toutv_admin_ui_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TouTv Admin - Offline (${var.env})"
  condition_display_name = "TouTv Admin - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.toutv_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.toutv_admin_ui_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.toutv_enable_alert
}

module "toutv_admin_be_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TouTv Admin BE - Offline (${var.env})"
  condition_display_name = "TouTv Admin BE - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.toutv_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.toutv_admin_be_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.toutv_enable_alert
}

module "toutv_premium_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TouTv Premium - Offline (${var.env})"
  condition_display_name = "TouTv Premium - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.toutv_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.toutv_premium_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.toutv_enable_alert
}

# All pods 'Error' in logs alert
module "toutv_error_alert_policy_private" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TouTv Errors"
  condition_display_name = "TouTv Errors"
  notif_id               = [data.google_monitoring_notification_channel.toutv_support.name]
  content                = "TouTv gke private error occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}\n\n"
  filter                 = "metric.type=\"logging.googleapis.com/user/toutv/error_count_private\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.toutv_enable_alert
}

module "toutv_error_alert_policy_public" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TouTv Errors"
  condition_display_name = "TouTv Errors"
  notif_id               = [data.google_monitoring_notification_channel.toutv_support.name]
  content                = "TouTv gke public error occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}\n\n"
  filter                 = "metric.type=\"logging.googleapis.com/user/toutv/error_count_public\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.toutv_enable_alert
}
