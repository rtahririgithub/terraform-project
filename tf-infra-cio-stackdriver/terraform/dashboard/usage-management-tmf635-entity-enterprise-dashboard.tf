#variable "mediation-b2b_project_id" {
#  type = string
#}

resource "google_monitoring_dashboard" "usage-management-tmf635-entity-enterprise_dashboard" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/usage-management-tmf635-entity-enterprise-dashboard.json", { project_id = var.mediation-b2b_project_id, env = var.env })
}
