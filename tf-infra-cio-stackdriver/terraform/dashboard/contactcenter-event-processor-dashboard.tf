variable "contactcenter_event_processor_project_id" {
  type    = string
  default = ""
}
variable "contactcenter_event_processor_project_id_vm_db" {
  type    = string
  default = "cdo-ccci-ods-np-46e1cd"
}
#container cpu request_utilization and cpu limit_utilization data possibly due to not specified in helm files
#use core_usage_time and uptime instead
resource "google_monitoring_dashboard" "contactctr_event-processor" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/contactcenter-event-processor-dashboard.json", { project_id = var.project_id, cluster_id = var.cio_gke_private_yul_001_project_id, contactcenter_event_processor_project_id = var.contactcenter_event_processor_project_id, contactcenter_event_processor_project_id_vm_db = var.contactcenter_event_processor_project_id_vm_db, namespace_name = "contactctr-api", env = var.env })
}
