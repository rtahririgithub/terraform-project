
variable "telusprivilege_database_id" {
  description = "database id for TELUS Privilege database"
  type        = string
}

variable "telusprivilege_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "telusprivilege_project_id" {
  type = string
}

locals {
  telusprivilege_admin_tool_ui_uptime_check_id   = data.terraform_remote_state.uptime.outputs.telusprivilege_admin_tool_ui_uptime_check.uptime_check_id[0]
  telusprivilege_admin_tool_be_uptime_check_id   = data.terraform_remote_state.uptime.outputs.telusprivilege_admin_tool_be_uptime_check.uptime_check_id[0]
  telusprivilege_support_tool_ui_uptime_check_id = data.terraform_remote_state.uptime.outputs.telusprivilege_support_tool_ui_uptime_check.uptime_check_id[0]
  telusprivilege_support_tool_be_uptime_check_id = data.terraform_remote_state.uptime.outputs.telusprivilege_support_tool_be_uptime_check.uptime_check_id[0]
  telusprivilege_content                         = file("${path.module}/telusprivilege-policy.md")
}

data "google_monitoring_notification_channel" "telusprivilege_support" {
  display_name = "TELUS Privilege Support"
  project      = var.project_id
}

# AdminTool Alert 
module "telusprivilege_admin_tool_ui_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TELUS Privilege AdminTool UI - Offline (${var.env})"
  condition_display_name = "TELUS Privilege AdminTool UI - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.telusprivilege_support.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.telusprivilege_admin_tool_ui_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.telusprivilege_enable_alert
}

module "telusprivilege_admin_tool_be_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TELUS Privilege AdminTool Backend - Offline (${var.env})"
  condition_display_name = "TELUS Privilege AdminTool Backend - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.telusprivilege_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.telusprivilege_admin_tool_be_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.telusprivilege_enable_alert
  content                = local.telusprivilege_content
}

# SupportTool Alert 
module "telusprivilege_support_tool_ui_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TELUS Privilege SupportTool UI - Offline (${var.env})"
  condition_display_name = "TELUS Privilege SupportTool UI - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.telusprivilege_support.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.telusprivilege_support_tool_ui_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.telusprivilege_enable_alert
}

module "telusprivilege_support_tool_be_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TELUS Privilege SupportTool Backend - Offline (${var.env})"
  condition_display_name = "TELUS Privilege SupportTool Backend - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.telusprivilege_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.telusprivilege_support_tool_be_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.telusprivilege_enable_alert
  content                = local.telusprivilege_content
}

# All pods 'Error' and 'Exception' in logs alert
module "telusprivilege_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TELUS Privilege Errors (${var.env})"
  condition_display_name = "TELUS Privilege Errors (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.telusprivilege_support.name]
  content                = "TELUS Privilege error occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}\n\n"
  filter                 = "metric.type=\"logging.googleapis.com/user/telusprivilege/error_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.telusprivilege_enable_alert
}
module "telusprivilege_cloudsql_server_down_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TELUS Privilege CloudSQL (${var.env}) CloudSQL database: ${var.telusprivilege_database_id} is down"
  condition_display_name = "${var.telusprivilege_database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.telusprivilege_support.name]
  content                = "CloudSQL database: ${var.telusprivilege_database_id} is down. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.telusprivilege_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = var.telusprivilege_enable_alert
}

module "telusprivilege_cloudsql_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TELUS Privilege CloudSQL (${var.env}) CPU utilization for CloudSQL database: ${var.telusprivilege_database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.telusprivilege_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.telusprivilege_support.name]
  content                = "CPU Utilization for CloudSQL database: ${var.telusprivilege_database_id} is at 80%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.telusprivilege_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.telusprivilege_enable_alert
}