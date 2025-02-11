variable "starter_kit_project_id" {
  type    = string
  default = ""
}

resource "google_monitoring_dashboard" "starter_kit_dashboard" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/starter-kit-dashboard.json", { starter_kit_project_id = var.starter_kit_project_id })
}