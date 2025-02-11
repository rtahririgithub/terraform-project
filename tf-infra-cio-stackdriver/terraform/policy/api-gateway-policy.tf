locals {
  apigw_private_yul_001 = data.terraform_remote_state.uptime.outputs.api_gateway_uptime_check.private-yul-001-apigw.uptime_check_id[0]
  apigw_public_yul_002  = data.terraform_remote_state.uptime.outputs.api_gateway_uptime_check.public-yul-002-apigw.uptime_check_id[0]

}


variable "apigw_policy_display_name" {
  description = "Display name for the policy"
  type        = string
  default     = "[Kong] https: %s Alert policy"
}

variable "apigw_threshold_value" {
  description = "Value the time series is compared with"
  default     = "1"
}

variable "apigw_duration" {
  description = "Duration (in seconds)"
  type        = string
  default     = "60s"
}

variable "apigw_alignment_period" {
  description = "Time interval for which aggregation takes place (in seconds)"
  type        = string
  default     = "300s"
}

variable "apigw_policy_combine" {
  description = "Combine method (OR or AND)"
  default     = "OR"
}

variable "apigw_policy_display_name_logmetric" {
  description = "Display name for the policy"
  type        = string
  default     = "[Kong] Alert policy - %s"
}

variable "apigw_per_series_aligner" {
  type    = string
  default = "ALIGN_COUNT"
}

variable "apigw_cross_series_reducer" {
  type    = string
  default = "REDUCE_COUNT"
}

variable "apigw_trigger_count" {
  type    = string
  default = 1
}

data "google_monitoring_notification_channel" "APIGatewayKongSupport" {
  display_name = "API Gateway Kong Support"
  project      = var.project_id
}

module "alert_policy_400_error" {
  count = var.env == "np" ? 1 : 0

  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = format(var.apigw_policy_display_name_logmetric, "40x error count")
  condition_display_name = format(var.apigw_policy_display_name_logmetric, "40x error count")
  notif_id               = [data.google_monitoring_notification_channel.APIGatewayKongSupport.name]
  trigger_count          = var.apigw_trigger_count
  per_series_aligner     = var.apigw_per_series_aligner
  cross_series_reducer   = var.apigw_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/private-yul-${var.env}-001/kong_lb/40x_error_count\" resource.type=\"l7_lb_rule\""
  enabled                = var.enable_notification
  duration               = var.apigw_duration
  alignment_period       = var.apigw_alignment_period
  group_by_fields        = ["resource.label.forwarding_rule_name", "metric.label.status"]
}

module "alert_policy_500_error" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = format(var.apigw_policy_display_name_logmetric, "40x error count")
  condition_display_name = format(var.apigw_policy_display_name_logmetric, "40x error count")
  notif_id               = [data.google_monitoring_notification_channel.APIGatewayKongSupport.name]
  trigger_count          = var.apigw_trigger_count
  per_series_aligner     = var.apigw_per_series_aligner
  cross_series_reducer   = var.apigw_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/private-yul-${var.env}-001/kong_lb/50x_error_count\" resource.type=\"l7_lb_rule\""
  enabled                = var.enable_notification
  duration               = var.apigw_duration
  alignment_period       = var.apigw_alignment_period
  group_by_fields        = ["resource.label.forwarding_rule_name", "metric.label.status"]
}

module "alert_policy_kong_private_001" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = format(var.apigw_policy_display_name, "apigw-private-yul-${var.env}-001.cloudapps.telus.com")
  condition_display_name = format(var.apigw_policy_display_name, "apigw-private-yul-${var.env}-001.cloudapps.telus.com")
  notif_id               = [data.google_monitoring_notification_channel.APIGatewayKongSupport.name]
  trigger_count          = var.apigw_trigger_count
  per_series_aligner     = var.apigw_per_series_aligner
  cross_series_reducer   = var.apigw_cross_series_reducer
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.apigw_private_yul_001}\""
  enabled                = var.enable_notification
  duration               = var.apigw_duration
  alignment_period       = var.apigw_alignment_period
}

module "alert_policy_kong_public_002" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = format(var.apigw_policy_display_name, "apigw-public-yul-${var.env}-002.cloudapps.telus.com")
  condition_display_name = format(var.apigw_policy_display_name, "apigw-public-yul-${var.env}-002.cloudapps.telus.com")
  notif_id               = [data.google_monitoring_notification_channel.APIGatewayKongSupport.name]
  trigger_count          = var.apigw_trigger_count
  per_series_aligner     = var.apigw_per_series_aligner
  cross_series_reducer   = var.apigw_cross_series_reducer
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.apigw_public_yul_002}\""
  duration               = var.apigw_duration
  alignment_period       = var.apigw_alignment_period
}