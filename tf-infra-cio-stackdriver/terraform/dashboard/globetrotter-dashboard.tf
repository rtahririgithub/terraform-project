variable "globetrotter_project_id" {
  type = string
}
resource "google_monitoring_dashboard" "globetrotter" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/globetrotter-dashboard.json", { project_id = var.project_id, globetrotter_project_id = var.globetrotter_project_id, env = var.env })
}