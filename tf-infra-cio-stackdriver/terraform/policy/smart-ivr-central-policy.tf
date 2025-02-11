variable "smart_ivr_database_id" {
  description = "Smart IVR database id"
  type        = string
  default     = ""
}

variable "smart_ivr_project_id" {
  description = "Smart IVR project id"
  type        = string
  default     = ""
}

variable "smart_ivr_uptime_check_id" {
  default = ""
}

# variable "smart_ivr_ui_raw_bucket" {
#   type    = string
#   default = ""
# }

locals {
  smart_ivr_uptime_check_id = var.smart_ivr_uptime_check_id
}

data "google_monitoring_notification_channel" "SmartIVRSupport" {
  display_name = "Smart IVR Support"
  project      = var.project_id
}

module "smart_ivr_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Smart IVR Central - Offline (${var.env})"
  condition_display_name = "Smart IVR Central - Offline (${var.env}) For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.SmartIVRSupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${local.smart_ivr_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}


module "smart_ivr_cloudsql_server_down_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Smart IVR CloudSQL database: ${var.smart_ivr_database_id} is down"
  condition_display_name = "${var.smart_ivr_database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.SmartIVRSupport.name]
  content                = "CloudSQL database: ${var.smart_ivr_database_id} is down. Please address issue."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.smart_ivr_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = true
}


module "smart_ivr_cloudsql_memory_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Smart IVR CloudSQL Memory utilization for CloudSQL database: ${var.smart_ivr_database_id}"
  condition_display_name = "Memory utilization for CloudSQL database: ${var.smart_ivr_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.SmartIVRSupport.name]
  content                = "Memory Utilization for CloudSQL database: ${var.smart_ivr_database_id} is at 90%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.smart_ivr_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.9"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = true
}

module "smart_ivr_cloudsql_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Smart IVR CloudSQL] [${var.env}] CPU utilization for CloudSQL database: ${var.smart_ivr_database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.smart_ivr_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.SmartIVRSupport.name]
  content                = "CPU Utilization for CloudSQL database: ${var.smart_ivr_database_id} is at 80%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.smart_ivr_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = true
}

module "smart_ivr_file_last_dropped_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Smart IVR Bucket] [${var.env}] File was last dropped in Bucket more than 24 hours ago"
  condition_display_name = "[${var.project_id}] File was last dropped in bucket more than 24 hours ago"
  notif_id               = [data.google_monitoring_notification_channel.SmartIVRSupport.name]
  content                = "File was last dropped in bucket more than 24 hours ago"
  filter                 = "metric.type=\"storage.googleapis.com/storage/object_count\" AND resource.type=\"gcs_bucket\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "86400s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "86400s"
  enabled                = true
}