variable "ams_project_id" {
  type    = string
  default = ""
}

resource "google_monitoring_dashboard" "ams_dashboard" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/ams-dashboard.json", { ams_project_id = var.ams_project_id, env = var.env })
}