locals {
  interconnect_content = file("${path.module}/interconnect-policy.md")
}

module "interconnect_alert_policy" {
  count                  = var.env == "pr" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Interconnect Status"
  condition_display_name = "Interconnect Status"
  notif_id = [
    data.google_monitoring_notification_channel.CloudCoE.name,
    data.google_monitoring_notification_channel.Orion.name,
    data.google_monitoring_notification_channel.TrueSight.name,
  ]
  trigger_count        = "1"
  per_series_aligner   = "ALIGN_COUNT_TRUE"
  cross_series_reducer = "REDUCE_NONE"
  comparison           = "COMPARISON_LT"
  alignment_period     = "60s"
  duration             = "0s"
  filter               = "(project=\"bto-vpc-host-6296f13b\" OR project=\"cio-interconnect-pr-8006aa\") metric.type=\"interconnect.googleapis.com/network/interconnect/operational\" resource.type=\"interconnect\" resource.label.\"interconnect\"!=\"torkonvo-eyrkonae-01\" resource.label.\"interconnect\"!=\"torkonvo-torkonvo-01\" resource.label.\"interconnect\"!=\"toroonxn-toroonxn-01\" resource.label.\"interconnect\"!=\"torkonvo-torkonvo-03\" resource.label.\"interconnect\"!=\"toroonxn-toroonxn-03\" resource.label.\"interconnect\"!=\"toroonxn-toroonxn-02\" resource.label.\"interconnect\"!=\"torkonvo-torkonvo-02\" "
  enabled              = var.enable_notification
  content              = local.interconnect_content
}
