locals {
  max_learned_routes                     = 200
  cloud_learned_routes_content           = file("${path.module}/cloud-learned-routes-policy.md")
  cloud_learned_routes_threshold_content = file("${path.module}/cloud-learned-routes-threshold-policy.md")
}

module "cloud_learned_routes_policy" {
  count                  = var.env == "pr" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Maximum Learned Routes Exceeded"
  condition_display_name = "Maximum Learned Routes Exceeded"
  notif_id = [
    data.google_monitoring_notification_channel.CloudCoE.name,
    data.google_monitoring_notification_channel.Orion.name,
    data.google_monitoring_notification_channel.TrueSight.name
  ]
  threshold_value      = tostring(local.max_learned_routes)
  trigger_count        = "1"
  per_series_aligner   = "ALIGN_MEAN"
  cross_series_reducer = "REDUCE_NONE"
  comparison           = "COMPARISON_GT"
  alignment_period     = "300s"
  duration             = "60s"
  filter               = "metric.type=\"router.googleapis.com/bgp/received_routes_count\" resource.type=\"gce_router\" metric.label.\"bgp_peer_name\"=\"mtlxvv03er10-00-bgp\""
  enabled              = var.enable_notification
  content              = local.cloud_learned_routes_content
}


module "cloud_learned_routes_threshold_policy" {
  count                  = var.env == "pr" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Learned Routes at 85%"
  condition_display_name = "Learned Routes at 85%"
  notif_id = [
    data.google_monitoring_notification_channel.CloudCoE.name,
    data.google_monitoring_notification_channel.Orion.name,
    data.google_monitoring_notification_channel.TrueSight.name
  ]
  threshold_value      = tostring(local.max_learned_routes * 0.85)
  trigger_count        = "1"
  per_series_aligner   = "ALIGN_MEAN"
  cross_series_reducer = "REDUCE_NONE"
  comparison           = "COMPARISON_GT"
  alignment_period     = "300s"
  duration             = "60s"
  filter               = "metric.type=\"router.googleapis.com/bgp/received_routes_count\" resource.type=\"gce_router\" metric.label.\"bgp_peer_name\"=\"mtlxvv03er10-00-bgp\""
  enabled              = var.enable_notification
  content              = local.cloud_learned_routes_threshold_content
}