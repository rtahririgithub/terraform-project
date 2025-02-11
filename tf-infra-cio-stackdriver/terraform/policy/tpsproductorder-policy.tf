variable "tps_product_order_project_id" {
  type    = string
  default = ""
}

variable "tps_product_order_enable_error_notification" {
  type    = bool
  default = false
}

locals {
  tps_monitored_product_order_project_id = var.tps_product_order_project_id
}

data "google_monitoring_notification_channel" "tpsapi_support" {
  display_name = "TPS API Support"
  project      = var.project_id
}

# ERROR ALERTING POLICIES
module "tps_agreement_mgmt_level_error_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TPS Agreement Mgmt SYSTEM API Level Errors"
  condition_display_name = "TPS Agreement Mgmt SYSTEM API Level Errors"
  notif_id               = [data.google_monitoring_notification_channel.tpsapi_support.name]
  content                = templatefile("${path.module}/tpsproductorder-error-policy.md", { project_id = local.tps_monitored_product_order_project_id })
  filter                 = "metric.type=\"logging.googleapis.com/user/oe-tps-prodcut-order/tps_agreement_mgmt/level_error_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "3"
  duration               = "60s"
  enabled                = var.tps_product_order_enable_error_notification
}