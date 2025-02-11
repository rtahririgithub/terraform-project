data "google_monitoring_notification_channel" "DRS" {
  display_name = "DRS Cache Service Notification Channel"
  project      = var.project_id
}


module "devicereturn_product_load_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "(DRS Cache Service) Hyla product load error"
  condition_display_name = "(DRS Cache Service) Hyla product load error"
  notif_id               = [data.google_monitoring_notification_channel.DRS.name]
  content                = "DRS Cache Service ($${resource.labels.container_name}) nightly product load has issues.\n\nPlease address these issues.\n\nmetric_type=$${metric.type}\n\nmetric_name=$${metric.display_name}\n\npolicy=$${policy.name}\n\npolicy_name=$${policy.display_name}\n\nproject=$${project}\n\nresource_project=$${resource.project}\n\nService name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/devicereturn_product_load/error_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_RATE"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = "true"
}