variable "apigw_project_id" {
  type = string
}
resource "google_monitoring_dashboard" "apigw-ops" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/apigw-ops-dashboard.json", { project_id = var.project_id, apigw_project_id = var.apigw_project_id, env = var.env })
}

resource "google_monitoring_dashboard" "apigw-private" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/apigw-private-dashboard.json", { project_id = var.project_id, apigw_project_id = var.apigw_project_id, env = var.env })
}