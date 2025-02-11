variable "mediation_project_id" {
  type = string
}
resource "google_monitoring_dashboard" "mediation" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/mediation-dashboard.json", { project_id = var.project_id, mediation_project_id = var.mediation_project_id, env = var.env })
}