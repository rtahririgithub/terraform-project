variable "contactcenter_customer_info_project_id" {
  type    = string
  default = ""
}
variable "contactcenter_customer_info_project_id_vm_db" {
  default = "cdo-ccci-ods-np-46e1cd"
}
#event processor do not have request 
resource "google_monitoring_dashboard" "contactctr_experience_api" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/contactcenter-customer-info-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, contactcenter_customer_info_project_id = var.contactcenter_customer_info_project_id, contactcenter_customer_info_project_id_vm_db = var.contactcenter_customer_info_project_id_vm_db, namespace_name = "contactctr-api", env = var.env })
}
