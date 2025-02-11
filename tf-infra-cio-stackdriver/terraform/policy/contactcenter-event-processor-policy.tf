variable "contactcenter_event_processor_enable_alert" {
  description = "enable the alert"
  type        = string
  default     = "false"
}

variable "contactcenter_event_processor_project_id" {
  description = "contactcenter_event_processor_project id"
  type        = string
  default     = ""
}


locals {
  contactcenter_event_processor_notification_name = format("contactcenter_event_processor_GCP_Support-%s Email", upper(var.env))
}


data "google_monitoring_notification_channel" "contactcenter_event_processor" {
  display_name = local.contactcenter_event_processor_notification_name
  project      = var.project_id
}

module "contactcenter_cods_event_processor_exception_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[contactcenter_cods_event_processor] contactcenter_cods_event_processor_exception"
  condition_display_name = "[contactcenter_cods_event_processor] contactcenter_cods_event_processor_exception"
  notif_id               = [data.google_monitoring_notification_channel.contactcenter_event_processor.name]
  content                = "contactcenter cods event processor Exception occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/contactcenter_cods_ep/Exception_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  duration               = "60s"
  trigger_count          = "1"
  enabled                = var.contactcenter_event_processor_enable_alert
}

module "contactcenter_cods_event_processor_container_restart_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[contactcenter_cods_event_processor] contactcenter_cods_event_processor_container_restarted"
  condition_display_name = "[contactcenter_cods_event_processor] contactcenter_cods_event_processor_container_restarted"
  notif_id               = [data.google_monitoring_notification_channel.contactcenter_event_processor.name]
  content                = "contactcenter cods event processor container restarted. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contactctr_api\" resource.label.\"container_name\"=starts_with(\"ccci-eventprocessor-cods-\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  duration               = "60s"
  trigger_count          = "1"
  enabled                = var.contactcenter_event_processor_enable_alert
}

module "contactcenter_kb_event_processor_exception_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[contactcenter_kb_event_processor] contactcenter_kb_event_processor_exception"
  condition_display_name = "[contactcenter_kb_event_processor] contactcenter_kb_event_processor_exception"
  notif_id               = [data.google_monitoring_notification_channel.contactcenter_event_processor.name]
  content                = "contactcenter kb event processor Exception occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/contactcenter_kb_ep/Exception_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  duration               = "60s"
  trigger_count          = "1"
  enabled                = var.contactcenter_event_processor_enable_alert
}

module "contactcenter_kb_event_processor_container_restart_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[contactcenter_kb_event_processor] contactcenter_kb_event_processor_container_restarted"
  condition_display_name = "[contactcenter_kb_event_processor] contactcenter_kb_event_processor_container_restarted"
  notif_id               = [data.google_monitoring_notification_channel.contactcenter_event_processor.name]
  content                = "contactcenter kb event processor container restarted. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contactctr_api\" resource.label.\"container_name\"=starts_with(\"ccci-eventprocessor-kb-\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  duration               = "60s"
  trigger_count          = "1"
  enabled                = var.contactcenter_event_processor_enable_alert
}