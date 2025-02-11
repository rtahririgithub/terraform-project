variable "myworld_project_id" {
  type = string
}

locals {
  myworld_monitored_project_id = var.myworld_project_id
  myworld_uptime_check_id      = data.terraform_remote_state.uptime.outputs.myworld_uptime_check.uptime_check_id[0]
  geo_uptime_check_id          = data.terraform_remote_state.uptime.outputs.myworld_geoserver_uptime_check.uptime_check_id[0]
}


module "myworld_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "https: MYWORLD ${var.env} alert policy"
  condition_display_name = "https: MYWORLD ${var.env} alert policy"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.myworld_uptime_check_id}\""
  enabled                = true
  content                = templatefile("${path.module}/myworld-policy.md", { project_id = local.myworld_monitored_project_id })
}

module "myworld_geoserver_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "https: MYWORLD GeoServer ${var.env} alert policy"
  condition_display_name = "https: MYWORLD GeoServer ${var.env} alert policy"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.geo_uptime_check_id}\""
  enabled                = true
  content                = templatefile("${path.module}/myworld-policy.md", { project_id = local.myworld_monitored_project_id })
}