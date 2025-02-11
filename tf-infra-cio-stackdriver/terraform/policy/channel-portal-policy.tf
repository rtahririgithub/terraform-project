variable "channel_portal_non_critical_support_channel_list" {
  description = "Channel portal non-critical notification channel name list"
  type        = list(any)
  default     = ["CPMS Support Email - dlMarvels_NPAlerts"]
}

variable "channel_portal_critical_support_channel_list" {
  description = "Channel portal critical notification channel name list"
  type        = list(any)
  default     = ["CPMS Support Email - dlMarvels_NPAlerts"]
}

variable "channel_portal_database_id" {
  description = "database id for channel_portal"
  type        = string
}

variable "channel_portal_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "channel_portal_project_id" {
  description = "channel_portal_project id"
  type        = string
}

data "google_monitoring_notification_channel" "channel_portal_non_critical_notification_channel_name_list" {
  for_each     = toset(var.channel_portal_non_critical_support_channel_list)
  project      = var.project_id
  display_name = each.key
}

data "google_monitoring_notification_channel" "channel_portal_critical_notification_channel_name_list" {
  for_each     = toset(var.channel_portal_critical_support_channel_list)
  project      = var.project_id
  display_name = each.key
}

module "alert_channel_portal_non_critical_memory_threshold" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Channel Portal Web - Non Critical Alert - Memory Threshold"
  condition_display_name = "Channel Portal Web - Non Critical Alert - Memory Threshold"
  notif_id               = [for o in data.google_monitoring_notification_channel.channel_portal_non_critical_notification_channel_name_list : o.name]
  threshold_value        = "0.9"
  per_series_aligner     = "ALIGN_MAX"
  cross_series_reducer   = "REDUCE_MAX"
  filter                 = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"web-dealer-channel-portal\""
  alignment_period       = "300s"
  group_by_fields        = ["resource.labels.container_name"]
  content                = templatefile("${path.module}/channel-portal-policy.md", { criticality = "non critical" })
}

module "alert_channel_portal_non_critical_cpu_threshold" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Channel Portal Web - Non Critical Alert - CPU Threshold"
  condition_display_name = "Channel Portal Web - Non Critical Alert - CPU Threshold"
  notif_id               = [for o in data.google_monitoring_notification_channel.channel_portal_non_critical_notification_channel_name_list : o.name]
  threshold_value        = "0.9"
  per_series_aligner     = "ALIGN_MAX"
  cross_series_reducer   = "REDUCE_MAX"
  filter                 = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"web-dealer-channel-portal\""
  alignment_period       = "300s"
  group_by_fields        = ["resource.labels.container_name"]
  content                = "CPU Utilization for PostgresSQL database: ${var.channel_portal_database_id} is at 80%."
}

module "cpl2_504_gateway_timeout_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Channel Portal Web - cpl2_504_Gateway_timeout"
  condition_display_name = "Channel Portal Web - cpl2_504_Gateway_timeout"
  notif_id               = [for o in data.google_monitoring_notification_channel.channel_portal_critical_notification_channel_name_list : o.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/chnlpart/cpl/cpl2_gateway_timeout\" resource.type=\"k8s_container\""
  content                = "504 gateway timeout error. Please address these issues."
  trigger_count          = "1"
  threshold_value        = "2"
  per_series_aligner     = "ALIGN_MAX"
  cross_series_reducer   = "REDUCE_MAX"
  alignment_period       = "60s"
  duration               = "0s"
  group_by_fields        = ["resource.labels.container_name"]
  enabled                = "true"
}

module "cpl2_user_login_elapsed_time_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Channel Portal Web - user_login_elapsed_time"
  condition_display_name = "Channel Portal Web - user_login_elapsed_time"
  notif_id               = [for o in data.google_monitoring_notification_channel.channel_portal_critical_notification_channel_name_list : o.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/chnlpart/cpl/user_login_elapsed_time\" resource.type=\"k8s_container\""
  content                = "user login time is over the threshold. Please address these issue."
  trigger_count          = "1"
  threshold_value        = "20000"
  per_series_aligner     = "ALIGN_PERCENTILE_99"
  cross_series_reducer   = "REDUCE_MAX"
  alignment_period       = "60s"
  duration               = "0s"
  group_by_fields        = ["resource.labels.container_name"]
  enabled                = "true"
}

module "channel_portal_PostgresSQL_CPU_Utilization_alert" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Channel Portal Web [${var.env}] cpu utilization for PostgresSQL database: ${var.channel_portal_database_id}"
  condition_display_name = "CPU utilization for PostgresSQL database: ${var.channel_portal_database_id} over threshold"
  notif_id               = [for o in data.google_monitoring_notification_channel.channel_portal_non_critical_notification_channel_name_list : o.name]
  content                = "CPU Utilization for PostgresSQL database: ${var.channel_portal_database_id} is at 80%. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.channel_portal_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.channel_portal_enable_alert
}

module "channel_portal_PostgresSQL_Memory_Utilization_alert" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Channel Portal Web [${var.env}] Memory utilization for PostgresSQL database: ${var.channel_portal_database_id}"
  condition_display_name = "Memory utilization for PostgresSQL database: ${var.channel_portal_database_id} over threshold"
  notif_id               = [for o in data.google_monitoring_notification_channel.channel_portal_non_critical_notification_channel_name_list : o.name]
  content                = "Memory Utilization for PostgresSQL database: ${var.channel_portal_database_id} is at 80%. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.channel_portal_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.channel_portal_enable_alert
}

module "channel_portal_PostgresSQL_Disk_Utilization_alert" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Channel Portal Web [${var.env}] disk utilization for PostgresSQL database: ${var.channel_portal_database_id}"
  condition_display_name = "disk utilization for PostgresSQL database: ${var.channel_portal_database_id} over threshold"
  notif_id               = [for o in data.google_monitoring_notification_channel.channel_portal_non_critical_notification_channel_name_list : o.name]
  content                = "disk utilization for PostgresSQL database: ${var.channel_portal_database_id} is at 80%. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/disk/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.channel_portal_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.channel_portal_enable_alert
}

module "channel_portal_PostgresSQL_connections_alert" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Channel Portal Web [${var.env}] PostgresSQL_connections for PostgresSQL database: ${var.channel_portal_database_id}"
  condition_display_name = "PostgresSQL_connections for PostgresSQL database: ${var.channel_portal_database_id} over threshold"
  notif_id               = [for o in data.google_monitoring_notification_channel.channel_portal_non_critical_notification_channel_name_list : o.name]
  content                = "PostgresSQL_connections for PostgresSQL database: ${var.channel_portal_database_id} is above 500. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.channel_portal_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "500"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.channel_portal_enable_alert
}