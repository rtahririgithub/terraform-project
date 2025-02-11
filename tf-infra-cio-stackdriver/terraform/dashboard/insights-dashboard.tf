variable "insights_project_id" {
  type    = string
  default = ""
}

variable "insights_namespace_name" {
  type    = string
  default = ""
}
variable "insights_cluster_name" {
  type    = string
  default = ""
}

variable "insights_bq_project_id" {
  type    = string
  default = ""
}



resource "google_monitoring_dashboard" "insights-public" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/insights-dashboard.json", { cluster_id = var.cio_gke_public_yul_002_project_id, insights_project_id = var.insights_project_id, insights_namespace_name = var.insights_namespace_name, insights_bq_project_id = var.insights_bq_project_id, insights_cluster_name = var.insights_cluster_name, env = var.env })
}

#resource "google_monitoring_dashboard" "insights-private" {
#  project        = var.project_id
#  dashboard_json = templatefile("${path.module}/insights-private-dashboard.json", { insights_private_api_container = var.insights_private_api_container, cluster_id = var.cio_gke_private_yul_001_project_id, insights_project_id = var.insights_project_id, env = var.env })
#}


