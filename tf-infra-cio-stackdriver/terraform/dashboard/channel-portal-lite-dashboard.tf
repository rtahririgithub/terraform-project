variable "channel_portal_project_id" {
  type    = string
  default = ""
}

variable "channel_portal_project_no" {
  type    = string
  default = ""
}

variable "cpl_web_container_name" {
  type    = string
  default = ""
}

variable "cpl_exp_container_name" {
  type    = string
  default = ""
}

locals {
  cpl_monitored_env = var.env == "np" ? "dv" : "pr"
}

resource "google_monitoring_dashboard" "channel-portal-lite-system-dashboard" {
  project = var.project_id
  dashboard_json = templatefile("${path.module}/channel-portal-lite-system-dashboard.json", {
    project_id             = var.channel_portal_project_id,
    project_no             = var.channel_portal_project_no,
    cpl_web_container_name = var.cpl_web_container_name,
    cpl_exp_container_name = var.cpl_exp_container_name,
    env                    = local.cpl_monitored_env
  })
}

resource "google_monitoring_dashboard" "channel-portal-lite-operation-dashboard" {
  project = var.project_id
  dashboard_json = templatefile("${path.module}/channel-portal-lite-operation-dashboard.json", {
    project_id             = var.channel_portal_project_id,
    project_no             = var.channel_portal_project_no,
    cpl_web_container_name = var.cpl_web_container_name,
    cpl_exp_container_name = var.cpl_exp_container_name,
    env                    = local.cpl_monitored_env
  })
}

resource "google_monitoring_dashboard" "channel-portal-lite-operation-dashboard-pilot" {
  project = var.project_id
  dashboard_json = templatefile("${path.module}/channel-portal-lite-operation-dashboard-pilot.json", {
    project_id             = var.channel_portal_project_id,
    project_no             = var.channel_portal_project_no,
    cpl_web_container_name = var.cpl_web_container_name,
    cpl_exp_container_name = var.cpl_exp_container_name,
    env                    = local.cpl_monitored_env
  })
}