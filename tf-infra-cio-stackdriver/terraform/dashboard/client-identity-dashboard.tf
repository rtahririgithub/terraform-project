variable "clientidentity_project_id" {
  type = string
}

variable "clientidentity_device_database_id" {
  type = string
}

variable "device_container_name" {
  type = string
}

variable "cm_container_name" {
  type = string
}

variable "otp_container_name" {
  type = string
}


resource "google_monitoring_dashboard" "clientidentity" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/clientidentity-dashboard.json", { project_id = var.project_id, location = "northamerica-northeast1", clientidentity_project_id = var.clientidentity_project_id, clientidentity_device_database_id = var.clientidentity_device_database_id, namespace_name = "id-cust-client-identity", device_container_name = var.device_container_name, cm_container_name = var.cm_container_name, otp_container_name = var.otp_container_name, env = var.env })
}
