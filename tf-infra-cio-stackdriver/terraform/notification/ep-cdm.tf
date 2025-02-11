variable "ep_project_id" {
  type    = string
  default = "cdo-horizon-np-26fa4c"
}

module "ep_cdm_cm_channel" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id   = var.project_id
  display_name = "ep-cdm-cm-channel"
  type         = "pubsub"
  pubsub_topic = "projects/${var.ep_project_id}/topics/cdm-cm-topic"
  enabled      = "true"
}