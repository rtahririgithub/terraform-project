module "msg_transformer_validation_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-notification-msg-transformer] validation error"
  condition_display_name = "[cio-notification-msg-transformer] validation error"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Msg Transformer Service ($${resource.labels.container_name}) data validation has issue.\n\nPlease address these issues.\n\nmetric_type=$${metric.type}\n\nmetric_name=$${metric.display_name}\n\npolicy=$${policy.name}\n\npolicy_name=$${policy.display_name}\n\nproject=$${project}\n\nresource_project=$${resource.project}\n\nService name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/comm-msg-transformer_validation_exception/error_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_RATE"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "10"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = "false"
}

module "msg_transformer_comm_api_exception_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-notification-msg-transformer] Comm API exception"
  condition_display_name = "[cio-notification-msg-transformer] Comm API exception"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Msg Transformer Service ($${resource.labels.container_name}) comm_api call has issue.\n\nPlease address these issues.\n\nmetric_type=$${metric.type}\n\nmetric_name=$${metric.display_name}\n\npolicy=$${policy.name}\n\npolicy_name=$${policy.display_name}\n\nproject=$${project}\n\nresource_project=$${resource.project}\n\nService name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/comm-msg-transformer_comm_api_exception/error_count\" AND resource.type=\"k8s_container\""
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

module "msg_transformer_comm_api_bad_input_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-notification-msg-transformer] Comm API bad input error"
  condition_display_name = "[cio-notification-msg-transformer] Comm API bad input error"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Msg Transformer Service ($${resource.labels.container_name}) comm_api had bad input issue.\n\nPlease address these issues.\n\nmetric_type=$${metric.type}\n\nmetric_name=$${metric.display_name}\n\npolicy=$${policy.name}\n\npolicy_name=$${policy.display_name}\n\nproject=$${project}\n\nresource_project=$${resource.project}\n\nService name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/comm-msg-transformer_comm_api_bad_input/error_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_RATE"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = "false"
}

module "msg_transformer_comm_api_system_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-notification-msg-transformer] Comm API system error"
  condition_display_name = "[cio-notification-msg-transformer] Comm API system error"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Msg Transformer Service ($${resource.labels.container_name}) comm_api had system error.\n\nPlease address these issues.\n\nmetric_type=$${metric.type}\n\nmetric_name=$${metric.display_name}\n\npolicy=$${policy.name}\n\npolicy_name=$${policy.display_name}\n\nproject=$${project}\n\nresource_project=$${resource.project}\n\nService name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/comm-msg-transformer_comm_api_system_error/error_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_RATE"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "10"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = "true"
}
