variable "cobra_sc_project_id" {
  type = string
}


resource "google_monitoring_dashboard" "cobra_sc" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/tsbt-surcharge-calculator-dashboard.json", { project_id = var.cobra_sc_project_id, env = var.env })
}