variable "nccs_project_id" {
  type    = string
  default = "cdo-comm-nccs-trl-stmt-np-5b65"
}

variable "nccs_service_environment" {
  type    = list(string)
  default = ["dev", "prodlike"]
}

resource "google_monitoring_dashboard" "comm-nccs-trl-stmt-error-handling" {
  for_each = toset(var.nccs_service_environment)
  project  = var.project_id
  dashboard_json = templatefile("${path.module}/comm-nccs-trl-stmt-dashboard-error-handling.json", {
    project_id = var.nccs_project_id
    env        = each.key
  })
}

resource "google_monitoring_dashboard" "comm-nccs-trl-stmt-performance" {
  for_each = toset(var.nccs_service_environment)
  project  = var.project_id
  dashboard_json = templatefile("${path.module}/comm-nccs-trl-stmt-dashboard-performance.json", {
    project_id     = var.nccs_project_id
    env            = each.key
    container-name = (var.env == "np") ? "nccs-service-${each.key}-${var.env}" : "nccs-service-${each.key}"
  })
}