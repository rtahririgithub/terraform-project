locals {
  vpc_limits_content = file("${path.module}/vpc-limits-policy.md")
}

module "internal_lb_forwarding_rule_limit_alert_policy" {
  count                  = var.env == "pr" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Internal LB Forwarding Rules Limit 80 Percent"
  condition_display_name = "Internal LB Forwarding Rules Limit 80 Percent"
  notif_id = [
    data.google_monitoring_notification_channel.CloudCoE.name
  ]
  trigger_count        = "80"
  per_series_aligner   = "ALIGN_MAX"
  cross_series_reducer = "REDUCE_NONE"
  comparison           = "COMPARISON_GT"
  # 1 day is 86400s
  alignment_period = "86400s"
  duration         = "0s"
  filter           = "project=\"bto-vpc-host-6296f13b\" metric.type=\"compute.googleapis.com/quota/internal_lb_forwarding_rules_per_vpc_network/usage\" resource.type=\"compute.googleapis.com/VpcNetwork\""
  enabled          = var.enable_notification
  content          = local.vpc_limits_content
}

module "internal_lb_forwarding_rule_limit_exceeded_alert_policy" {
  count                  = var.env == "pr" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Internal LB Forwarding Rules Limit Exceeded"
  condition_display_name = "Internal LB Forwarding Rules Limit Exceeded"
  notif_id = [
    data.google_monitoring_notification_channel.CloudCoE.name
  ]
  trigger_count        = "0"
  per_series_aligner   = "ALIGN_MAX"
  cross_series_reducer = "REDUCE_NONE"
  comparison           = "COMPARISON_GT"
  alignment_period     = "60s"
  duration             = "0s"
  filter               = "project=\"bto-vpc-host-6296f13b\" metric.type=\"compute.googleapis.com/quota/internal_protocol_forwarding_rules_per_vpc_network/exceeded\" resource.type=\"compute.googleapis.com/VpcNetwork\""
  enabled              = var.enable_notification
  content              = local.vpc_limits_content
}