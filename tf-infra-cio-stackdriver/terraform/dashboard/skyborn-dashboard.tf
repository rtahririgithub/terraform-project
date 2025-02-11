variable "skyborn_project_id" {
  type = string
}
resource "google_monitoring_dashboard" "skyborn" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/skyborn-dashboard.json", { project_id = var.project_id, skyborn_project_id = var.skyborn_project_id, env = var.env })
}