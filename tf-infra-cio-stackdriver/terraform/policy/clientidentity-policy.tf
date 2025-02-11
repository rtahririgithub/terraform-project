variable "clientidentity_device_database_id" {
  description = "device database id for clientidentity"
  type        = string
}

variable "clientidentity_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "clientidentity_project_id" {
  description = "clientidentity project id"
  type        = string
}

locals {
  clientidentity_email_display_name = "Clientidentity Notification Channel"
}

data "google_monitoring_notification_channel" "clientidentity_support" {
  display_name = local.clientidentity_email_display_name
  project      = var.project_id
}

module "clientidentity_cloudsql_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[clientidentity CloudSQL] [${var.env}] CPU utilization for CloudSQL database: ${var.clientidentity_device_database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.clientidentity_device_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.clientidentity_support.name]
  content                = "CPU Utilization for CloudSQL database: ${var.clientidentity_device_database_id} is at 80%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.clientidentity_device_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_MAX"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.clientidentity_enable_alert
}

module "clientidentity_pod_restart_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[clientidentity] [${var.env}] POD Restart"
  condition_display_name = "POD Restart over threshold"
  notif_id               = [data.google_monitoring_notification_channel.clientidentity_support.name]
  content                = "POD Restart is above 2 "
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"id-cust-client-identity\""
  group_by_fields        = ["resource.label.container_name"]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "2"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.clientidentity_enable_alert
}

