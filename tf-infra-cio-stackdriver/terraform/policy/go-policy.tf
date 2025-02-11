variable "go_project_id" {
  type = string
}

locals {
  go_check_id          = data.terraform_remote_state.uptime.outputs.go_uptime_check.uptime_check_id[0]
  env                  = var.env == "np" ? "dv" : "pr"
  monitored_project_id = var.go_project_id
}


data "google_monitoring_notification_channel" "go-support" {
  display_name = "Go Support"
  project      = var.project_id
}

module "go_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "https: GO ${local.env} alert policy"
  condition_display_name = "https: GO ${local.env} alert policy"
  notif_id               = [data.google_monitoring_notification_channel.go-support.name, data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.go_check_id}\""
  enabled                = true
  content                = templatefile("${path.module}/go-policy.md", { project_id = local.monitored_project_id })
}