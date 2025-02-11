variable "enabled_custbill_retrieval_error" {
  description = "eBill retrieval error alert enabled"
  type        = string
}

variable "enabled_custbill_retrieval_container_restart" {
  description = "eBill retrieval container restart alert enabled"
  type        = string
}

module "ecp_custbill_retrieval_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-notification-eBill] Custbill Retrieval Error - eBill Proration"
  condition_display_name = "[cio-notification-eBill] Custbill Retrieval Error - eBill Proration"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Custbill Retrieval (eBill Proration) ($${resource.labels.container_name}) has encountered error.\n\nPlease address these issues.\n\nCheck the log here: ${var.custbill_retrieval_log_url}"
  filter                 = "metric.type=\"logging.googleapis.com/user/notification_custbill_retrieval/error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "10"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.enabled_custbill_retrieval_error
}

module "ecp_custbill_retrieval_container_restart_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-notification-eBill] Custbill Retrieval Container Restart - eBill Proration"
  condition_display_name = "[cio-notification-eBill] Custbill Retrieval Container Restart - eBill Proration"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Custbill Retrieval (eBill Proration) ($${resource.labels.container_name}) has Restarted.\n\nCheck the log here: ${var.custbill_retrieval_log_url}"
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=monitoring.regex.full_match(\"private-yul-.*\") resource.label.\"container_name\"=\"custbill-retrieval\""
  group_by_fields        = ["resource.label.container_name"]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.enabled_custbill_retrieval_container_restart
}
