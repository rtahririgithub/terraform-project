variable "b2b_usage_consumption_project_id" {
  type    = string
  default = ""
}
resource "google_monitoring_dashboard" "b2b_usage_consumption" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/b2b-usage-consumption-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, b2b_usage_consumption_project_id = var.b2b_usage_consumption_project_id, namespace_name = "usage-consumption-b2b", env = var.env })
}
