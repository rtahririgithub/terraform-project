variable "geodata_integration_project_id" {
  type    = string
  default = ""

}

resource "google_monitoring_dashboard" "geodata-integration" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/geodata-integration-dashboard.json", { geodata_integration_project_id = var.geodata_integration_project_id })
}