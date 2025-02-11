variable "merlin_databases" {
  type    = list(string)
  default = [""]
}

variable "merlin_project_id_vm_db" {
  default = "cio-nc-cloud-core-np-28a0c4"
}


resource "google_monitoring_dashboard" "merlin-nc-cloud-bss-db-instance-performance-dashboard" {
  project        = var.project_id
  dashboard_json = var.env == "np" ? templatefile("${path.module}/merlin-nc-cloud-bss-db-instance-performance-np.json", { merlin_project_id_vm_db = var.merlin_project_id_vm_db, merlin_databases = var.merlin_databases }) : templatefile("${path.module}/merlin-nc-cloud-bss-db-instance-performance-pr.json", { merlin_project_id_vm_db = var.merlin_project_id_vm_db, merlin_databases = var.merlin_databases })
}

resource "google_monitoring_dashboard" "merlin-nc-cloud-bss-performance-monitoring-dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/merlin-nc-cloud-bss-performance-monitoring.json", { gke_merlin_project = var.cio_gke_private_yul_001_project_id })
}
