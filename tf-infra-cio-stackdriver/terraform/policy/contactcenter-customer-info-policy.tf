variable "contactcenter_customer_info_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "contactcenter_customer_info_project_id" {
  description = "contactcenter_customer_info_project id"
  type        = string
}


locals {
  contactcenter_customer_info_notification_name = format("contactcenter_api_GCP_Support-%s Email", upper(var.env))
}


data "google_monitoring_notification_channel" "contactcenter_customer_info" {
  display_name = local.contactcenter_customer_info_notification_name
  project      = var.project_id
}

module "contactcenter_customer_info_exception_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[contactcenter_customer_info_api] contactcenter_customer_info_exception"
  condition_display_name = "[contactcenter_customer_info_api] contactcenter_customer_info_exception"
  notif_id               = [data.google_monitoring_notification_channel.contactcenter_customer_info.name]
  content                = "contactcenter customer info api Exception occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/contactcenter_customer_info_api/Exception_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "12"
  comparison             = "COMPARISON_GT"
  duration               = "60s"
  trigger_count          = "1"
  enabled                = var.contactcenter_customer_info_enable_alert
}

module "contactcenter_customer_info_4xx_status_code_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[contactcenter_customer_info_api] contactcenter_customer_info_4xx_status_code_alert"
  condition_display_name = "[contactcenter_customer_info_api] contactcenter_customer_info_4xx_status_code_alert"
  notif_id               = [data.google_monitoring_notification_channel.contactcenter_customer_info.name]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  cross_series_reducer   = "REDUCE_SUM"
  filter                 = "metric.type=\"logging.googleapis.com/user/contactcenter_customer_info_api/status_code_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contactctr-api\" metric.label.\"status_code\">=400 metric.label.\"status_code\"<500"
  enabled                = var.contactcenter_customer_info_enable_alert
  duration               = "60s"
  alignment_period       = "60s"
  threshold_value        = "10"
  trigger_count          = "1"
  group_by_fields        = ["resource.labels.container_name", "metric.label.status_code"]
  content                = templatefile("${path.module}/contactcenter_customer_info_status_code-code.md", { api = "contactctr customerinfo api", level = "error" })
}

module "contactcenter_customer_info_5xx_or_above_status_code_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[contactcenter_customer_info_api] contactcenter_customer_info_5xx_or_above_status_code_alert"
  condition_display_name = "[contactcenter_customer_info_api] contactcenter_customer_info_5xx_or_above_status_code_alert"
  notif_id               = [data.google_monitoring_notification_channel.contactcenter_customer_info.name]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  cross_series_reducer   = "REDUCE_SUM"
  filter                 = "metric.type=\"logging.googleapis.com/user/contactcenter_customer_info_api/status_code_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contactctr-api\" metric.label.\"status_code\">=500"
  enabled                = var.contactcenter_customer_info_enable_alert
  duration               = "60s"
  alignment_period       = "60s"
  threshold_value        = "2"
  trigger_count          = "1"
  group_by_fields        = ["resource.labels.container_name", "metric.label.status_code"]
  content                = templatefile("${path.module}/contactcenter_customer_info_status_code-code.md", { api = "contactctr customerinfo api", level = "error" })
}

module "contactcenter_customer_info_other_error_status_code_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[contactcenter_customer_info_api] contactcenter_customer_info_other_error_status_code_alert"
  condition_display_name = "[contactcenter_customer_info_api] contactcenter_customer_info_other_error_status_code_alert"
  notif_id               = [data.google_monitoring_notification_channel.contactcenter_customer_info.name]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  cross_series_reducer   = "REDUCE_SUM"
  filter                 = "metric.type=\"logging.googleapis.com/user/contactcenter_customer_info_api/status_code_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contactctr-api\" metric.label.\"status_code\"<400 metric.label.\"status_code\"!=200 metric.label.\"status_code\"!=201"
  enabled                = var.contactcenter_customer_info_enable_alert
  duration               = "60s"
  alignment_period       = "60s"
  threshold_value        = "3"
  trigger_count          = "1"
  group_by_fields        = ["resource.labels.container_name", "metric.label.status_code"]
  content                = templatefile("${path.module}/contactcenter_customer_info_status_code-code.md", { api = "contactctr customerinfo api", level = "error" })
}
