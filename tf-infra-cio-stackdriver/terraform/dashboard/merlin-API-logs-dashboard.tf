
variable "gke_merlin_project_logs" {
  type    = string
  default = "cio-gke-private-yul-001-2396bd"
}
variable "merlin_project_id_metric_env" {
  default = "nc_private_yul_pr"
}
locals {
  api_monitored_env = var.env == "np" ? "np" : "pr"
}

resource "google_monitoring_dashboard" "merlin-nc-cloud-bss-api-logs-monitoring-dashboard" {
  count          = 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/merlin-logs-api-${local.api_monitored_env}.json", { gke_merlin_project = var.gke_merlin_project_logs })
}