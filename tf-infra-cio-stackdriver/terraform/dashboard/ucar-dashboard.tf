variable "datahub_projects" {
  type = map(any)
}

resource "google_monitoring_dashboard" "ucar_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/ucar-dashboard.json", { dashboard_project_id = var.project_id, gke_ucar_api_project_id = var.cio_gke_private_yul_001_project_id, bt_ucar_api_project_id = var.datahub_projects["enterprise"], bq_ucar_data_project_id = var.datahub_projects["work"], env = var.env })
}

