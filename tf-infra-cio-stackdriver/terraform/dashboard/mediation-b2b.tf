variable "mediation-b2b_project_id" {
  type = string
}

variable "mediation-b2b_database_id" {
  type = string
}

resource "google_monitoring_dashboard" "mediation-b2b" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/mediation-b2b-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, mediation-b2b_project_id = var.mediation-b2b_project_id, mediation-b2b_database_id = var.mediation-b2b_database_id, namespace_name = "mediation-data", env = var.env })
}
