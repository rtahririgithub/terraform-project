variable "tess_project_id" {
  type = string
}
resource "google_monitoring_dashboard" "tess" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/tess-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, tess_project_id = var.tess_project_id, env = var.env })
}

resource "google_monitoring_dashboard" "tess-cpcdrs" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/tess-cpcdrs-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, tess_project_id = var.tess_project_id, env = var.env })
}
