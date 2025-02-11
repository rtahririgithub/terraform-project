variable "cust_prof_project_id" {
  type    = string
  default = "cio-cust-prof-np-f19f85"
}

variable "cust_prof_service_containers" {
  type    = list(string)
  default = ["stage", "it01", "it02", "it03", "prodlike"]
}

variable "gke_private_yul_001_project_number" {
  type    = string
  default = "167665948143"
}

resource "google_monitoring_dashboard" "cust_prof_events_performance_dashboard" {
  for_each = toset(var.cust_prof_service_containers)
  project  = var.project_id
  dashboard_json = templatefile("${path.module}/cust-prof-events-performance-monitoring.tftpl", {
    gke_project_id       = var.cio_gke_private_yul_001_project_id
    cust_prof_container  = each.key
    cust_prof_env        = var.env
    cust_prof_project_id = var.cust_prof_project_id
  })
}

resource "google_monitoring_dashboard" "cust_prof_http_requests_performance_dashboard" {
  for_each = toset(var.cust_prof_service_containers)
  project  = var.project_id
  dashboard_json = templatefile("${path.module}/cust-prof-http-performance-monitoring.tftpl", {
    gke_project_id       = var.cio_gke_private_yul_001_project_id
    cust_prof_container  = each.key
    cust_prof_env        = var.env
    cust_prof_project_id = var.cust_prof_project_id
  })
}

resource "google_monitoring_dashboard" "cust_prof_app_current_state_dashboard" {
  for_each = toset(var.cust_prof_service_containers)
  project  = var.project_id
  dashboard_json = templatefile("${path.module}/cust-prof-app-current-state-dashboard.tftpl", {
    gke_project_id       = var.cio_gke_private_yul_001_project_id
    cust_prof_container  = each.key
    cust_prof_env        = var.env
    cust_prof_project_id = var.cust_prof_project_id
    gke_project_number   = var.gke_private_yul_001_project_number
  })
}
