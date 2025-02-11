variable "creditmgmt_project_id" {
  type = string
}
resource "google_monitoring_dashboard" "creditmgmt" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/creditmgmt-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, creditmgmt_project_id = var.creditmgmt_project_id, namespace_name = "cio-creditmgmt", env = var.env })
}
