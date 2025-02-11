variable "tpsbooking_project_id" {
  type    = string
  default = ""
}

variable "tpsbooking_enable_alert" {
  type    = string
  default = false
}

data "google_monitoring_notification_channel" "tpsbooking_support" {
  display_name = "TPS Booking Support"
  project      = var.project_id
}


locals {
  # tpsbooking_ui_uptime_check_id = var.env == "np" ? data.terraform_remote_state.uptime.outputs.tpsbooking_ui_uptime_check.uptime_check_id[0] : "void"
  tpsbooking_ui_uptime_check_id = "fixme"
  tpsbooking_content            = file("${path.module}/tpsbooking-policy.md")
}

module "tpsbooking_ui_uptime_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TPS Booking Frontend - Offline (${var.env})"
  condition_display_name = "TPS Booking Frontend - Offline (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.tpsbooking_support.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.tpsbooking_ui_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = var.tpsbooking_enable_alert
  content                = local.tpsbooking_content
}