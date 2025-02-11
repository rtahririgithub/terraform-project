variable "cloudmigrator_project_id" {
  type = string
}
resource "google_monitoring_dashboard" "cloudmigrator" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/migrator-dashboard.json", { project_id = var.project_id, cloudmigrator_project_id = var.cloudmigrator_project_id, env = var.env })
}