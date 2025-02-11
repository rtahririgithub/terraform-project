variable "creditmgmt_database_id" {
  description = "database id for creditmgmt"
  type        = string
}

variable "creditmgmt_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "creditmgmt_project_id" {
  description = "creditmgmt_project id"
  type        = string
}


locals {
  creditmgmt_notification_name = format("CreditCollection_GCP_Support-%s Email", upper(var.env))
}


data "google_monitoring_notification_channel" "creditmgmt" {
  display_name = local.creditmgmt_notification_name
  project      = var.project_id
}

module "creditmgmt_exception_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[creditmgmt] creditmgmt_exception"
  condition_display_name = "[creditmgmt] creditmgmt_exception"
  notif_id               = [data.google_monitoring_notification_channel.creditmgmt.name]
  content                = "creditmgmt Exception occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/creditmgmt/Exception_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_RATE"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.creditmgmt_enable_alert
}

module "creditmgmt_cloudsql_server_down_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[creditmgmt CloudSQL] [${var.env}] CloudSQL database: ${var.creditmgmt_database_id} is down"
  condition_display_name = "${var.creditmgmt_database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.creditmgmt.name]
  content                = "CloudSQL database: ${var.creditmgmt_database_id} is down. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.creditmgmt_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = var.creditmgmt_enable_alert
}

module "creditmgmt_cloudsql_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[creditmgmt CloudSQL] [${var.env}] CPU utilization for CloudSQL database: ${var.creditmgmt_database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.creditmgmt_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.creditmgmt.name]
  content                = "CPU Utilization for CloudSQL database: ${var.creditmgmt_database_id} is at 80%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.creditmgmt_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.creditmgmt_enable_alert
}

module "creditmgmt_cloudsql_disk_bytes_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[creditmgmt CloudSQL] [${var.env}] disk_bytes utilization for CloudSQL database: ${var.creditmgmt_database_id}"
  condition_display_name = "disk_bytes utilization for CloudSQL database: ${var.creditmgmt_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.creditmgmt.name]
  content                = "disk_bytes utilization for CloudSQL database: ${var.creditmgmt_database_id} is at 20%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/disk/bytes_used\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.creditmgmt_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "70000000000"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.creditmgmt_enable_alert
}

module "creditmgmt_pubsub_subscription_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[creditmgmt Pubsub] [${var.env}] creditmgmt Pubsub unacked message"
  condition_display_name = "creditmgmt Pubsub subscription unacked message count over threshold"
  notif_id               = [data.google_monitoring_notification_channel.creditmgmt.name]
  content                = "## Pubsub subscription unacked message over the threashold\n This could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\n"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.creditmgmt_project_id}\"  resource.labels.subscription_id != has_substring(\"creditprofileevent\")  "
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "43200s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "20000"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "86400s"
  enabled                = var.creditmgmt_enable_alert
}