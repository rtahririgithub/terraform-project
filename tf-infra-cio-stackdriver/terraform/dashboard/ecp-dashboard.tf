variable "ecp_project_id" {
  type = string
}
variable "springboot_admin_ui" {
  type = string
}
resource "google_monitoring_dashboard" "ecp" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/ecp-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, ecp_project_id = var.ecp_project_id, env = var.env, springboot_admin_ui = var.springboot_admin_ui, wnp_dashboard_id = element(split("/", google_monitoring_dashboard.wnp.id), 3) })
}

resource "google_monitoring_dashboard" "ecp-alt" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/ecp-dashboard-alt.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, ecp_project_id = var.ecp_project_id, env = var.env })
}

resource "google_monitoring_dashboard" "wnp" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/wnp-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, ecp_project_id = var.ecp_project_id, env = var.env })
}