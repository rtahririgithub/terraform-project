variable "techhub_project_id" {
  type = string
}

variable "techhub_jarr_api_container" {
  type = string
}

variable "techhub_ui_container" {
  type = string
}

resource "google_monitoring_dashboard" "techub" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/techhub-ui-dashboard.json", { techhub_ui_container = var.techhub_ui_container, cluster_id = var.cio_gke_public_yul_002_project_id, techhub_project_id = var.techhub_project_id, env = var.env })
}

resource "google_monitoring_dashboard" "techub-jarr" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/techhub-jarr-dashboard.json", { techhub_jarr_api_container = var.techhub_jarr_api_container, cluster_id = var.cio_gke_private_yul_001_project_id, techhub_project_id = var.techhub_project_id, env = var.env })
}