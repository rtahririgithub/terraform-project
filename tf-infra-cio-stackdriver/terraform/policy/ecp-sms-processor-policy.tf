variable "roaming_sms_processor_log_url" {
  type = string
}

module "ecp_notify-roaming-sms-processor_error_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[notify-roaming-sms-processor] Roaming SMS Processor Error"
  condition_display_name = "[notify-roaming-sms-processor] Roaming SMS Processor Error"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Roaming SMS Processor ($${resource.labels.container_name}) has encountered error.\n\nPlease address these issues.\n\nCheck the log here: ${var.roaming_sms_processor_log_url} \n\n metric_type=$${metric.type}\n\nmetric_name=$${metric.display_name}\n\npolicy=$${policy.name}\n\npolicy_name=$${policy.display_name}\n\nproject=$${project}\n\nresource_project=$${resource.project}\n\nService name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/notify-roaming-sms-processor/error_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = "true"
}