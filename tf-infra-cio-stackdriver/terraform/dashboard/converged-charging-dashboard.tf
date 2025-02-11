variable "converged_charging_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "converged_charging" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/converged-charging-dashboard.json", { project_id = var.converged_charging_project_id, env = var.env })
}