variable "equip_warranty_project_id" {
  type    = string
  default = ""
}

variable "equip_warranty_unhandled_error_metric" {
  type    = string
  default = ""
}

variable "equip_warranty_http_gateway_error_metric" {
  type    = string
  default = ""
}

variable "equip_warranty_http_gateway_error_timeout_metric" {
  type    = string
  default = ""
}

variable "ews_poq_container_name" {
  type    = string
  default = ""
}

data "google_monitoring_notification_channel" "dl_rhinos_support" {
  display_name = "dl Rhinos Support"
  project      = var.project_id
}

module "equip_warranty_unhandled_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "EWS-POQ - Unhandled Error"
  condition_display_name = "EWS-POQ - Unhandled Error"
  notif_id               = [data.google_monitoring_notification_channel.dl_rhinos_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/equip-warranty/${var.equip_warranty_unhandled_error_metric}\" resource.type=\"k8s_container\""
  content                = "Unhandled error. Please address these issues."
  trigger_count          = "1"
  threshold_value        = "0.0"
  per_series_aligner     = "ALIGN_RATE"
  cross_series_reducer   = "REDUCE_NONE"
  alignment_period       = "60s"
  duration               = "0s"
  enabled                = "true"
}

module "equip_warranty_http_gateway_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "EWS-POQ - Http Gateway Error"
  condition_display_name = "EWS-POQ - Http Gateway Error"
  notif_id               = [data.google_monitoring_notification_channel.dl_rhinos_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/equip-warranty/${var.equip_warranty_http_gateway_error_metric}\" resource.type=\"k8s_container\""
  content                = "Http gateway error. Please address these issues to the developers of downstream services."
  trigger_count          = "1"
  threshold_value        = "100"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_SUM"
  alignment_period       = "360s"
  duration               = "0s"
  enabled                = "true"
}

module "equip_warranty_http_gateway_error_timeout_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "EWS-POQ - Http Gateway Error TIMEOUT"
  condition_display_name = "EWS-POQ - Http Gateway Error TIMEOUT"
  notif_id               = [data.google_monitoring_notification_channel.dl_rhinos_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/equip-warranty/${var.equip_warranty_http_gateway_error_timeout_metric}\" resource.type=\"k8s_container\""
  content                = "Http gateway TIMEOUT error. Please address these issues to the developers of downstream services."
  trigger_count          = "1"
  threshold_value        = "25"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_SUM"
  alignment_period       = "60s"
  duration               = "0s"
  enabled                = "true"
}

module "ews_poq_container_restart_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "EWS-POQ - Container restart"
  condition_display_name = "EWS-POQ - Container restart"
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"equip-warranty\" resource.label.\"container_name\"=\"${var.ews_poq_container_name}\""
  notif_id               = [data.google_monitoring_notification_channel.dl_rhinos_support.name]
  content                = "Application restart for too many times. Please address these issues to the developers"
  trigger_count          = "1"
  threshold_value        = "2"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_SUM"
  alignment_period       = "43200s"
  duration               = "0s"
  enabled                = "true"
}
