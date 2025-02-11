variable "iqt_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "iqt_project_id" {
  type = string
}

locals {
  iqt_ui_uptime_check_id = data.terraform_remote_state.uptime.outputs.iqt_ui_uptime_check.uptime_check_id[0]
  iqt_be_uptime_check_id = data.terraform_remote_state.uptime.outputs.iqt_be_uptime_check.uptime_check_id[0]
}

data "google_monitoring_notification_channel" "iqt_support" {
  display_name = "IQT Support"
  project      = var.project_id
}

# UI Uptime alert 
module "iqt_ui_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "IQT UI - Offline (${var.env})"
  condition_display_name = "IQT UI - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.iqt_support.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.iqt_ui_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.iqt_enable_alert
}

module "iqt_be_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "IQT Backend - Offline (${var.env})"
  condition_display_name = "IQT Backend - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.iqt_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.iqt_be_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.iqt_enable_alert
}

# All pods 'Error' and 'Exception' in logs alert
# prod alert for old cluster
module "iqt_error_alert_policy" {
  count                  = var.env == "np" ? 0 : 1
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "IQT Errors"
  condition_display_name = "IQT Errors"
  notif_id               = [data.google_monitoring_notification_channel.iqt_support.name]
  content                = "IQT error occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}\n\n"
  filter                 = "metric.type=\"logging.googleapis.com/user/iqt/error_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.iqt_enable_alert
}

# nonprod alert for new cluster
module "iqt_error_alert_policy_newcluster" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "IQT Errors"
  condition_display_name = "IQT Errors"
  notif_id               = [data.google_monitoring_notification_channel.iqt_support.name]
  content                = "IQT error occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}\n\n"
  filter                 = "metric.type=\"logging.googleapis.com/user/sales-tq-iqt-error-count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.iqt_enable_alert
}
