

resource "google_monitoring_dashboard" "merlin-nc-cloud-bss-capcity-monitoring-dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/merlin-capacity.json", { gke_merlin_project = var.cio_gke_private_yul_001_project_id })
}