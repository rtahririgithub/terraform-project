variable "privacy_database_id" {
  description = "database id for privacy api"
  type        = string
}

variable "privacy_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "privacy_project_id" {
  description = "privacy project id"
  type        = string
}

variable "privacyprofile_log_url" {
  description = "privacy profile log url"
  type        = string
}

module "privacy_cloudsql_server_up_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Privacy CloudSQL] [${var.env}] CloudSQL database: ${var.privacy_database_id} is down"
  condition_display_name = "${var.privacy_database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.Privacy.name]
  content                = "CloudSQL database: ${var.privacy_database_id} is down. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.privacy_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = "true"
}

module "privacy_cloudsql_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Privacy CloudSQL] [${var.env}] CPU utilization for CloudSQL database: ${var.privacy_database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.privacy_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.Privacy.name]
  content                = "CPU Utilization for CloudSQL database: ${var.privacy_database_id} is at 20%. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.privacy_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.2"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.privacy_enable_alert
}

module "privacy_cloudsql_memory_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Privacy CloudSQL] [${var.env}] Memory utilization for CloudSQL database: ${var.privacy_database_id}"
  condition_display_name = "Memory utilization for CloudSQL database: ${var.privacy_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.Privacy.name]
  content                = "Memory Utilization for CloudSQL database: ${var.privacy_database_id} is at 50%. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.privacy_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.5"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.privacy_enable_alert
}
