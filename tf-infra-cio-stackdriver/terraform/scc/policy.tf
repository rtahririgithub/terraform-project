data "google_monitoring_notification_channel" "channels" {
  project      = var.project_id
  for_each     = toset(local.channel_names)
  display_name = each.value

}

data "google_monitoring_notification_channel" "default_channel" {
  project      = var.project_id
  display_name = var.default_channel
}

locals {
  display_names            = [for s in data.google_monitoring_notification_channel.channels : s.display_name]
  ids                      = [for s in data.google_monitoring_notification_channel.channels : s.id]
  notification_channel_map = zipmap(local.display_names, local.ids)

  channel_names = distinct(flatten([
    for mp_key, mp in var.monitored_projects : [
  for display_name in mp.display_names : display_name]]))
}

output "notification_map" {
  value = local.notification_channel_map
}

module "scc_policy" {
  source               = "git::ssh://git@github.com/telus/tf-module-gcp-scc-policy?ref=v0.3.1%2Btf.0.13.3"
  project_id           = var.project_id
  enabled              = var.enable_notification
  for_each             = var.monitored_projects
  monitored_project_id = each.value.monitored_project_id
  notification_channels = [
    for name in each.value.display_names : lookup(local.notification_channel_map, name, data.google_monitoring_notification_channel.default_channel.id)
  ]
}