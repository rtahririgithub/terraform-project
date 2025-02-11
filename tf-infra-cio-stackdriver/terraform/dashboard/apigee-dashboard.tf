variable "apigee_project_id" {
  type    = string
  default = ""
}

variable "apigee_project_number" {
  type    = string
  default = ""
}

variable "apigee_env" {
  type    = string
  default = ""
}

resource "google_monitoring_dashboard" "apigee-dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/apigee-dashboard.json", { apigee_policy_id = lookup(data.external.alert_policies.result, "[acxux_apigee_proxies] apigee_proxies_info_exception"), apigee_project_number = var.apigee_project_number, apigee_env = var.apigee_env })
}
