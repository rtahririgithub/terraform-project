variable "cust_prof_enable_notification" {
  type    = string
  default = "true"
}

variable "cust_prof_project_id" {
  type    = string
  default = "cio-cust-prof-np-f19f85"
}

variable "cust_prof_support_email" {
  type    = string
  default = "florin.bacica@telus.com"
}

module "cust_prof_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id    = var.project_id
  display_name  = "Customer Profile Dataflow Support"
  email_address = var.cust_prof_support_email
  enabled       = var.cust_prof_enable_notification
}

module "cust_prof_pubsub_notification_channel" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=master"
  project_id   = var.project_id
  display_name = "Customer Profile Pubsub Support"
  type         = "pubsub"
  pubsub_topic = "projects/${var.cust_prof_project_id}/topics/cust-prof-service-alerts-${var.env}"
  enabled      = var.cust_prof_enable_notification
}