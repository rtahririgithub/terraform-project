variable "csag_duration" {
  description = "Duration (in seconds)"
  type        = string
  default     = "1800s"
}

variable "csag_critical_duration" {
  description = "Duration (in seconds)"
  type        = string
  default     = "900s"
}

variable "csag_alignment_period" {
  description = "Time interval for which aggregation takes place (in seconds)"
  type        = string
  default     = "300s"
}

variable "csag_policy_display_name_logmetric" {
  description = "Display name for the policy"
  type        = string
  default     = "CSAG API Alert policy - %s"
}

variable "csag_per_series_aligner" {
  type    = string
  default = "ALIGN_MEAN"
}

variable "csag_cross_series_reducer" {
  type    = string
  default = "REDUCE_SUM"
}

variable "csag_trigger_count" {
  type    = string
  default = 1
}

variable "csag_critical_trigger_count" {
  type    = string
  default = 1
}

variable "csag_non_critical_threshold_count" {
  type    = string
  default = 5
}

variable "csag_critical_threshold_count" {
  type    = string
  default = 2
}

data "google_monitoring_notification_channel" "CSAGSupport" {
  display_name = "CSAG Support"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "CSAG_Critical_Pager_Support" {
  display_name = "CSAG Critical Pager Support"
  project      = var.project_id
}

module "alert_csag_document_api_non_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG document api non critical alert"
  condition_display_name = "CSAG document api non critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name]
  trigger_count          = var.csag_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/document_api_non_critical_error\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\""
  threshold_value        = var.csag_non_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "document api", level = "non critical" })
}

module "alert_csag_document_api_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG document api critical alert"
  condition_display_name = "CSAG document api critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name, data.google_monitoring_notification_channel.CSAG_Critical_Pager_Support.name]
  trigger_count          = var.csag_critical_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/document_api_critical_error\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\""
  threshold_value        = var.csag_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_critical_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "document api", level = "critical" })
}

module "alert_csag_document_list_api_non_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG document list api non critical alert"
  condition_display_name = "CSAG document list api non critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name]
  trigger_count          = var.csag_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/document_list_api_non_critical_error\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\""
  threshold_value        = var.csag_non_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "document list api", level = "non critical" })
}

module "alert_csag_document_list_api_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG document list api critical alert"
  condition_display_name = "CSAG document list api critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name, data.google_monitoring_notification_channel.CSAG_Critical_Pager_Support.name]
  trigger_count          = var.csag_critical_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/document_list_api_critical_error\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\""
  threshold_value        = var.csag_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_critical_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "document list api", level = "critical" })
}

module "alert_csag_accessory_finance_api_non_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG accessory finance api non critical alert"
  condition_display_name = "CSAG accessory finance api non critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name]
  trigger_count          = var.csag_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/accessory_finance_api_non_critical_error\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\""
  threshold_value        = var.csag_non_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "accessory finance api", level = "non critical" })
}

module "alert_csag_accessory_finance_api_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG accessory finance api critical alert"
  condition_display_name = "CSAG accessory finance api critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name, data.google_monitoring_notification_channel.CSAG_Critical_Pager_Support.name]
  trigger_count          = var.csag_critical_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/accessory_finance_api_critical_error\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\""
  threshold_value        = var.csag_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_critical_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "accessory finance api", level = "critical" })
}

module "alert_csag_wls_koodo_api_non_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG wls koodo api non critical alert"
  condition_display_name = "CSAG wls koodo api non critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name]
  trigger_count          = var.csag_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/wls_koodo_api_non_critical_error\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\""
  threshold_value        = var.csag_non_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "wls koodo api", level = "non critical" })
}

module "alert_csag_wls_koodo_api_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG wls koodo api critical alert"
  condition_display_name = "CSAG wls koodo api critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name, data.google_monitoring_notification_channel.CSAG_Critical_Pager_Support.name]
  trigger_count          = var.csag_critical_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/wls_koodo_api_critical_error\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\""
  threshold_value        = var.csag_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_critical_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "wls koodo api", level = "critical" })
}

module "alert_csag_wln_fifa_api_non_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG wln fifa api non critical alert"
  condition_display_name = "CSAG wln fifa api non critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name]
  trigger_count          = var.csag_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/error_response_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\" resource.label.\"container_name\"=starts_with(\"cio-csag-wlnfifa-api\") metric.labels.\"error_code\"=starts_with(\"4\")"
  threshold_value        = var.csag_non_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "wln fifa api", level = "non critical" })
}

module "alert_csag_wln_fifa_api_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG wln fifa api critical alert"
  condition_display_name = "CSAG wln fifa api critical alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name, data.google_monitoring_notification_channel.CSAG_Critical_Pager_Support.name]
  trigger_count          = var.csag_critical_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/error_response_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"contract-cons-csag\" resource.label.\"container_name\"=starts_with(\"cio-csag-wlnfifa-api\") metric.labels.\"error_code\"=starts_with(\"5\")"
  threshold_value        = var.csag_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_critical_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "wln fifa api", level = "critical" })
}

module "alert_csag_kong_critical_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CSAG microservice timeout error alert"
  condition_display_name = "CSAG microservice timeout error alert"
  notif_id               = [data.google_monitoring_notification_channel.CSAGSupport.name, data.google_monitoring_notification_channel.CSAG_Critical_Pager_Support.name]
  trigger_count          = var.csag_critical_trigger_count
  per_series_aligner     = var.csag_per_series_aligner
  cross_series_reducer   = var.csag_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/csag/csag_kong_timeout_error\" resource.type=\"l7_lb_rule\""
  threshold_value        = var.csag_critical_threshold_count
  enabled                = var.enable_notification
  duration               = var.csag_critical_duration
  alignment_period       = var.csag_alignment_period
  group_by_fields        = ["resource.labels.container_name", "metric.label.error_code"]
  content                = templatefile("${path.module}/csag-api-policy.md", { api = "microservice timeout", level = "critical" })
} 