variable "d2c_project_id" {
  type = string
}



resource "google_monitoring_dashboard" "d2c_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/d2c-dashboard.json", { d2c_project_id = var.d2c_project_id, env = var.env })
}