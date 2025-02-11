variable "mediation-whsia-tmf635_database_id" {
  description = "database id for mediation-whsia-tmf635"
  type        = string
  default     = "cio-mediation-data-np-c0f674:mediation-b2b-np-d6cf"
}

variable "mediation-whsia-tmf635_enable_alert" {
  description = "enable the alert"
  type        = string
  default     = "false"
}

variable "mediation-whsia-tmf635-enterprise_enable_alert" {
  description = "enable the alert"
  type        = string
  default     = "true"
}

variable "mediation-whsia-tmf635_project_id" {
  description = "mediation-whsia-tmf635_project id"
  type        = string
  default     = "cio-mediation-data-np-c0f674"
}


locals {
  mediation-whsia-tmf635_notification_name = format("Mediation-WHSIA-TMF635_GCP_Support-%s Email", upper(var.env))
  mediation-whsia-tmf635_personal_name     = format("Mediation-WHSIA-TMF635_Personal-Support-%s Email", upper(var.env))
}


data "google_monitoring_notification_channel" "mediationtmf635mgmt" {
  display_name = local.mediation-whsia-tmf635_notification_name
  project      = var.project_id
}

data "google_monitoring_notification_channel" "mediationtmf635personal" {
  display_name = local.mediation-whsia-tmf635_personal_name
  project      = var.project_id
}

module "mediation-whsia-tmf635-enterprise_exception_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-enterprise-tmf635][${var.env}] mediation-enterprise-tmf635_exception"
  condition_display_name = "[Mediation-enterprise-tmf635][${var.env}] mediation-enterprise-tmf635_exception"
  notif_id               = [data.google_monitoring_notification_channel.mediationtmf635personal.name]
  content                = "mediation Exception occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/mediation_tmf635/mediation_usage_management_enterprise_exception_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "5"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mediation-whsia-tmf635-enterprise_enable_alert
}

module "mediation-whsia-tmf635-whsia_exception_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-whsia-tmf635][${var.env}] mediation-tmf635-whsia_exception"
  condition_display_name = "[Mediation-whsia-tmf635][${var.env}] mediation-tmf635-whsia_exception"
  notif_id               = [data.google_monitoring_notification_channel.mediationtmf635personal.name]
  content                = "mediation Exception occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/mediation_tmf635/mediation_usage_management_whsia_exception_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "5"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mediation-whsia-tmf635_enable_alert
}

module "mediation-whsia-tmf635_api_response_code_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-enterprise-tmf635][${var.env}] mediation-enterprise-tmf635_api_response_code_alert"
  condition_display_name = "[Mediation-enterprise-tmf635][${var.env}] mediation-enterprise-tmf635_api_response_code_alert"
  notif_id               = [data.google_monitoring_notification_channel.mediationtmf635personal.name]
  threshold_value        = "1"
  per_series_aligner     = "ALIGN_MAX"
  cross_series_reducer   = "REDUCE_MAX"
  filter                 = "metric.type=\"logging.googleapis.com/user/mediation_tmf635/mediation_usage_management_enterprise/api_status_code_count\" resource.type=\"k8s_container\" metric.label.\"response_code\" != \"200 OK\""
  alignment_period       = "60s"
  group_by_fields        = ["metric.label.API_ID"]
  content                = "# respond_code not equal to 200, Please address the issue.\n\n API_ID: $${metric.label.API_ID}"
}

module "mediation-whsia-tmf635_api_response_time_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-enterprise-tmf635][${var.env}] mediation-enterprise-tmf635_api_response_time_alert"
  condition_display_name = "[Mediation-enterprise-tmf635][${var.env}] mediation-enterprise-tmf635_api_response_time_alert"
  notif_id               = [data.google_monitoring_notification_channel.mediationtmf635personal.name]
  threshold_value        = "10000"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_MEAN"
  filter                 = "metric.type=\"logging.googleapis.com/user/mediation_tmf635/mediation_usage_management_enterprise/api_response_times\" resource.type=\"k8s_container\""
  group_by_fields        = ["metric.label.API_ID"]
  alignment_period       = "60s"
  content                = "API_ID: $${metric.label.API_ID}"
}