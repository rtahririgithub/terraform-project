variable "enabled_wnp_processor_error" {
  description = "wnp processor error alert enabled"
  type        = string
}

data "google_monitoring_notification_channel" "wnp_support" {
  display_name = "WNP Support Channel"
  project      = var.project_id
}

module "ecp_wnp_processor_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "(cio-notification-wnp) WNP Processor Error"
  condition_display_name = "(cio-notification-wnp) WNP Processor Error"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name, data.google_monitoring_notification_channel.wnp_support.name]
  content                = "WNP Processor ($${resource.labels.container_name}) has encountered error.\n\nPlease address these issues.\n\nCheck the log here: ${var.wnp_processor_log_url}"
  filter                 = "metric.type=\"logging.googleapis.com/user/notification_wnp_processor/error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enabled_wnp_processor_error
}
