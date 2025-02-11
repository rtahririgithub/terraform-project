variable "equip_inventory_project_id" {
  type = string
}

variable "equip_inventory_unhandled_error_metric" {
  type = string
}

variable "equip_inventory_http_gateway_error_metric" {
  type = string
}

variable "equip_goods_movement_unhandled_error_metric" {
  type    = string
  default = ""
}

variable "equip_goods_movement_processing_failed_metric" {
  type    = string
  default = ""
}

data "google_monitoring_notification_channel" "dl_sharks_support" {
  display_name = "dl Sharks Support"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "gm_dev_support" {
  display_name = "GM Dev Support"
  project      = var.project_id
}

####################################
####### EQUIP-INVENTORY-LOAD #######
####################################

module "equip_inventory_unhandled_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "EQUIP-INVENTORY - Unhandled Error"
  condition_display_name = "EQUIP-INVENTORY - Unhandled Error"
  notif_id               = [data.google_monitoring_notification_channel.dl_sharks_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/equip-inventory/${var.equip_inventory_unhandled_error_metric}\" resource.type=\"k8s_container\""
  content                = "Unhandled error. Please address these issues."
  trigger_count          = "1"
  threshold_value        = "0.0"
  per_series_aligner     = "ALIGN_RATE"
  cross_series_reducer   = "REDUCE_NONE"
  alignment_period       = "60s"
  duration               = "0s"
  enabled                = "true"
}

module "equip_inventory_http_gateway_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "EQUIP-INVENTORY - Http Gateway Error"
  condition_display_name = "EQUIP-INVENTORY - Http Gateway Error"
  notif_id               = [data.google_monitoring_notification_channel.dl_sharks_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/equip-inventory/${var.equip_inventory_http_gateway_error_metric}\" resource.type=\"k8s_container\""
  content                = "Http gateway error. Please address these issues to the developers of downstream services."
  trigger_count          = "1"
  threshold_value        = "5"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_NONE"
  alignment_period       = "300s"
  duration               = "0s"
  enabled                = "true"
}

####################################
####### EQUIP-GOODS-MOVEMENT #######
####################################

module "equip_goods_movement_unhandled_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "EQUIP-GOODS-MOVEMENT - Unhandled Error"
  condition_display_name = "EQUIP-GOODS-MOVEMENT - Unhandled Error"
  notif_id               = [data.google_monitoring_notification_channel.gm_dev_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/equip-inventory/${var.equip_goods_movement_unhandled_error_metric}\" resource.type=\"k8s_container\""
  content                = "Unhandled error. Please address this issue."
  trigger_count          = "1"
  threshold_value        = "0.0"
  per_series_aligner     = "ALIGN_RATE"
  cross_series_reducer   = "REDUCE_NONE"
  alignment_period       = "60s"
  duration               = "0s"
  enabled                = var.env == "pr" ? "true" : "false"
}

module "equip_goods_movement_processing_failed_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "EQUIP-GOODS-MOVEMENT - File processing failed"
  condition_display_name = "EQUIP-GOODS-MOVEMENT - File processing failed"
  notif_id               = [data.google_monitoring_notification_channel.gm_dev_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/equip-inventory/${var.equip_goods_movement_processing_failed_metric}\" resource.type=\"k8s_container\""
  content                = "File processing failed. Please address this issue."
  trigger_count          = "1"
  threshold_value        = "0.0"
  per_series_aligner     = "ALIGN_RATE"
  cross_series_reducer   = "REDUCE_NONE"
  alignment_period       = "60s"
  duration               = "0s"
  enabled                = var.env == "pr" ? "true" : "false"
}
