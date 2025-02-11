locals {
  vm_instance_name      = "crawford-vm"
  bigtable_instance_id  = "bpr-bti-billdoc"
  bpr_notification_name = format("Bill Presentment Notification-%s Email", upper(var.env))
}

data "google_monitoring_notification_channel" "BillPresentment" {
  display_name = local.bpr_notification_name
  project      = var.project_id
}

variable "billextraction_project_id" {
  description = "billextraction project id"
  type        = string
}

variable "billimagestore_project_id" {
  description = "billimagestore project id"
  default     = "cio-billing-extraction-np-d24c"
  type        = string
}

module "cio_billing_extraction_bigtable_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "(cio-billing-extraction) CPU load for bigtable instance: ${local.bigtable_instance_id}"
  condition_display_name = "(cio-billing-extraction) CPU load for bigtable instance: ${local.bigtable_instance_id}"
  notif_id               = [data.google_monitoring_notification_channel.BillPresentment.name]
  content                = "CPU load for bigTable instance: ${local.bigtable_instance_id} is at 90%. Please address these issues."
  filter                 = "metric.type=\"bigtable.googleapis.com/cluster/cpu_load\" resource.type=\"bigtable_cluster\" resource.label.\"project_id\"=\"${var.billextraction_project_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.9"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.enable_notification
}

module "cio_billing_extraction_bigtable_storage_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "(cio-billing-extraction) Storage utilization for bigtable instance: ${local.bigtable_instance_id}"
  condition_display_name = "(cio-billing-extraction) Storage utilization for bigtable instance: ${local.bigtable_instance_id}"
  notif_id               = [data.google_monitoring_notification_channel.BillPresentment.name]
  content                = "Storage Utilization for bigTable instance: ${local.bigtable_instance_id} is at 70%. Please address these issues."
  filter                 = "metric.type=\"bigtable.googleapis.com/cluster/storage_utilization\" resource.type=\"bigtable_cluster\"  resource.label.\"project_id\"=\"${var.billextraction_project_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.7"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.enable_notification
}

module "cio_bill_imagestore_vm_crawford_disk_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "(cio-bill-imagestore) Disk utilization for crawford vm instance: ${local.vm_instance_name}"
  condition_display_name = "(cio-bill-imagestore) Disk utilization for crawford vm instance: ${local.vm_instance_name}"
  notif_id               = [data.google_monitoring_notification_channel.BillPresentment.name]
  content                = "Disk utilization for crawford vm instance: ${local.vm_instance_name} is at 90%. Please address these issues."
  filter                 = "metric.type=\"agent.googleapis.com/disk/percent_used\" resource.type=\"gce_instance\" metadata.system_labels.\"name\"=\"${local.vm_instance_name}\" metric.label.\"device\"=\"root\" metric.label.\"state\"=\"used\" resource.label.\"project_id\"=\"${var.billimagestore_project_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "90"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.enable_notification
}

module "cio_bill_imagestore_memory_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "(cio-bill-imagestore) Memory utilization for crawford vm instance: ${local.vm_instance_name}"
  condition_display_name = "(cio-bill-imagestore) Memory utilization for crawford vm instance: ${local.vm_instance_name}"
  notif_id               = [data.google_monitoring_notification_channel.BillPresentment.name]
  content                = "Memory Utilization for crawford vm: ${local.vm_instance_name} is at 80%. Please address these issues."
  filter                 = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\" metric.label.\"state\"=\"used\" metadata.system_labels.\"name\"=\"${local.vm_instance_name}\" resource.label.\"project_id\"=\"${var.billimagestore_project_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "80"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.enable_notification
}
