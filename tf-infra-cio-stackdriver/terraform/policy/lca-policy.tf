locals {
  lca_uptime_check_id = data.terraform_remote_state.uptime.outputs.lca_uptime_check.uptime_check_id[0]
}



module "lca_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "https: LCA ${var.env} URL Alert policy"
  condition_display_name = "https: LCA ${var.env} URL Alert policy"
  notif_id               = [data.google_monitoring_notification_channel.CloudCoE.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.lca_uptime_check_id}\""
  enabled                = var.enable_notification
}

