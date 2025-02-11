module "sms_comm_third_party_adaptor_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-notify-sms-comm-third-party-adaptor] error"
  condition_display_name = "[cio-notify-sms-comm-third-party-adaptor] error"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Sms Comm Third Party Adaptor Service ($${resource.labels.container_name}) has issues.\n\nPlease address them.\n\nmetric_type=$${metric.type}\n\nmetric_name=$${metric.display_name}\n\npolicy=$${policy.name}\n\npolicy_name=$${policy.display_name}\n\nproject=$${project}\n\nresource_project=$${resource.project}\n\nService name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/notify-sms-comm-third-party-adaptor/error_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_RATE"
  alignment_period       = "120s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0.1666"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = "true"
}
