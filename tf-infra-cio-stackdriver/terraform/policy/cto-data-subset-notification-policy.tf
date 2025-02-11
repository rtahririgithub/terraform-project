variable "data-subset_project_id" {
  type    = string
  default = "cto-data-subset-np-f7c98f"
}

variable "data-subset_environment" {
  type    = string
  default = "prodlike"
}

variable "data-subset_database_id" {
  type    = string
  default = "data-subset-db-np"
}

variable "data-subset_gke_console_url" {
  type    = string
  default = "https://console.cloud.google.com/kubernetes/deployment/northamerica-northeast1/private-na-ne1-001/tdm-data-subset/data-subset-prodlike-np/overview?authuser=0&project=cdo-gke-private-np-1a8686"
}

data "google_monitoring_notification_channel" "dl_data_subset_support" {
  display_name = "Data Subset Email Support"
  project      = var.project_id
}

module "data-subset_container_restart_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - Container keeps restarting - ${var.data-subset_environment}"
  condition_display_name = "Data Subset - Container keeps restarting - ${var.data-subset_environment}"
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"tdm-data-subset\" resource.label.\"container_name\"=\"data-subset-${var.data-subset_environment}${(var.env == "np") ? "-np" : ""}\""
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  trigger_count          = "1"
  threshold_value        = "5"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_MAX"
  alignment_period       = "43200s"
  duration               = "600s"
  enabled                = "true"
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "Container keeps restarting",
    message                 = "Application keeps restarting. Please verify.",
    number_of_events        = "5 restarts",
    time_interval           = "12 hours",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}

module "data-subset_database_server_down_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - CloudSQL database is down"
  condition_display_name = "Data Subset - CloudSQL database is down"
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  filter                 = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.data-subset_project_id}:${var.data-subset_database_id}\" AND metric.type = \"cloudsql.googleapis.com/database/up\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = "true"
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "CloudSQL database is down",
    message                 = "CloudSQL database: ${var.data-subset_database_id} is down. Please verify.",
    number_of_events        = "1",
    time_interval           = "5 minutes",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}

module "data-subset-bad_request_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - Bad Request - ${var.data-subset_environment}"
  condition_display_name = "Data Subset - Bad Request - ${var.data-subset_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/data-subset-bad-request-${var.data-subset_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = (var.env == "np") ? "25" : "10"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  group_by_fields        = ["metric.label.processType"]
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "Bad Request",
    message                 = "Application keeps returning Bad Request. Please verify",
    number_of_events        = (var.env == "np") ? "25 occurrences" : "10 occurrences",
    time_interval           = "5 minutes",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}

module "data-subset-unhandled_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - Unhandled Error - ${var.data-subset_environment}"
  condition_display_name = "Data Subset - Unhandled Error - ${var.data-subset_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/data-subset-unhandled-error-${var.data-subset_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "Unhandled Error",
    message                 = "Application has an unhandled error. Please verify.",
    number_of_events        = "1 occurrence",
    time_interval           = "1 minute",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}

module "data-subset-too_many_not_found_jobs_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - Too many not found jobs - ${var.data-subset_environment}"
  condition_display_name = "Data Subset - Too many not found jobs - ${var.data-subset_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/data-subset-job-not-found-error-${var.data-subset_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "3600s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = (var.env == "np") ? "50" : "20"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "Jobs Not Found",
    message                 = "Application identified too many not found jobs. Please verify.",
    number_of_events        = (var.env == "np") ? "50 not found jobs" : "20 not found jobs",
    time_interval           = "1 hour",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}

module "data-subset-http_gateway_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - HTTP Gateway Error - ${var.data-subset_environment}"
  condition_display_name = "Data Subset - HTTP Gateway Error - ${var.data-subset_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/data-subset-http-gateway-error-${var.data-subset_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "5"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "HTTP Gateway Error",
    message                 = "Application has identified some HTTP gateway errors. Please verify.",
    number_of_events        = "5 occurrences",
    time_interval           = "5 minutes",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}

module "data-subset-http_contract_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - HTTP Contract Error - ${var.data-subset_environment}"
  condition_display_name = "Data Subset - HTTP Contract Error - ${var.data-subset_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/data-subset-http-contract-error-${var.data-subset_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "5"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "HTTP Contract Error",
    message                 = "Application has identified some HTTP contract errors. Please verify.",
    number_of_events        = "5 occurrences",
    time_interval           = "5 minutes",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}

module "data-subset-invalid_state_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - Invalid State Error - ${var.data-subset_environment}"
  condition_display_name = "Data Subset - Invalid State Error - ${var.data-subset_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/data-subset-invalid-state-error-${var.data-subset_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "5"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "Invalid State Error",
    message                 = "Application has identified some invalid state errors. Please verify.",
    number_of_events        = "5 occurrences",
    time_interval           = "5 minutes",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}

module "data-subset-job_execution_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Data Subset - Job Execution Error - ${var.data-subset_environment}"
  condition_display_name = "Data Subset - Job Execution Error - ${var.data-subset_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_data_subset_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/data-subset-job-execution-error-${var.data-subset_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "3600s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "5"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cto-data-subset-notification-policy.md", {
    environment             = (var.env == "np") ? "Non-Production" : "Production",
    alert_message           = "Job Execution Error",
    message                 = "Application has identified some job execution errors. Please verify.",
    number_of_events        = "5 occurrences",
    time_interval           = "1 hour",
    data_subset_gke_console = var.data-subset_gke_console_url
  })
}