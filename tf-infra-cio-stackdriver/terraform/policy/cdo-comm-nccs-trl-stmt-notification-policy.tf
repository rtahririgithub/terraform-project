variable "comm-nccs-trl-stmt_project_id" {
  type    = string
  default = "cdo-comm-nccs-trl-stmt-np-5b65"
}

variable "comm-nccs-trl-stmt_environment" {
  type    = string
  default = "prodlike"
}

variable "comm-nccs-trl-stmt_database_id" {
  type    = string
  default = "comm-nccs-trl-stmt-db-b-np"
}

variable "comm-nccs-trl-stmt_gke_console_url" {
  type    = string
  default = "https://console.cloud.google.com/kubernetes/deployment/northamerica-northeast1/private-na-ne1-001/comm-nccs/nccs-service-prodlike-np/overview?authuser=0&project=cdo-gke-private-np-1a8686"
}

data "google_monitoring_notification_channel" "dl_nccs_support" {
  display_name = "Corporate Stores Commission Statements Email Support"
  project      = var.project_id
}

module "comm-nccs-trl-stmt_container_restart_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - API container keeps restarting - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - API container keeps restarting - ${var.comm-nccs-trl-stmt_environment}"
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"comm-nccs\" resource.label.\"container_name\"=\"nccs-service-${var.comm-nccs-trl-stmt_environment}${(var.env == "np") ? "-np" : ""}\""
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  trigger_count          = "1"
  threshold_value        = "5"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_MAX"
  alignment_period       = "43200s"
  duration               = "600s"
  enabled                = "true"
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "API container keeps restarting",
    message          = "API keeps restarting. Please verify.",
    number_of_events = "5 restarts",
    time_interval    = "12 hours",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt_ui_container_restart_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - UI container keeps restarting - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - UI container keeps restarting - ${var.comm-nccs-trl-stmt_environment}"
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"comm-nccs\" resource.label.\"container_name\"=\"nccs-ui-${var.comm-nccs-trl-stmt_environment}${(var.env == "np") ? "-np" : ""}\""
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  trigger_count          = "1"
  threshold_value        = "5"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_MAX"
  alignment_period       = "43200s"
  duration               = "600s"
  enabled                = "true"
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "UI container keeps restarting",
    message          = "UI keeps restarting. Please verify.",
    number_of_events = "5 restarts",
    time_interval    = "12 hours",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt_database_server_down_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - CloudSQL database is down"
  condition_display_name = "Corporate Stores Commission Statements - CloudSQL database is down"
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  filter                 = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.comm-nccs-trl-stmt_project_id}:${var.comm-nccs-trl-stmt_database_id}\" AND metric.type = \"cloudsql.googleapis.com/database/up\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = "true"
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "CloudSQL database is down",
    message          = "CloudSQL database: ${var.comm-nccs-trl-stmt_database_id} is down. Please verify.",
    number_of_events = "1",
    time_interval    = "5 minutes",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt-bad_request_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - Bad Request - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - Bad Request - ${var.comm-nccs-trl-stmt_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/nccs-api-bad-request-metric-${var.comm-nccs-trl-stmt_environment}\""
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
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "Bad Request",
    message          = "Application keeps returning Bad Request. Please verify",
    number_of_events = (var.env == "np") ? "25 occurrences" : "10 occurrences",
    time_interval    = "5 minutes",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt-unhandled_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - Unhandled Error - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - Unhandled Error - ${var.comm-nccs-trl-stmt_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/nccs-api-unhandled-error-metric-${var.comm-nccs-trl-stmt_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "Unhandled Error",
    message          = "Application has an unhandled error. Please verify.",
    number_of_events = "1 occurrence",
    time_interval    = "1 minute",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt-too_many_not_found_statement_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - Too many not found statements - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - Too many not found statements - ${var.comm-nccs-trl-stmt_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/nccs-api-not-found-metric-${var.comm-nccs-trl-stmt_environment}\" AND metric.labels.processType = monitoring.regex.full_match(\".*(Statement|Report).*\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "3600s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = (var.env == "np") ? "100" : "50"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "Statements Not Found",
    message          = "Application identified too many not found statement. Please verify.",
    number_of_events = (var.env == "np") ? "100 not found statements" : "50 not found statements",
    time_interval    = "1 hour",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt-too_many_not_found_reps_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - Too many not found reps - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - Too many not found reps - ${var.comm-nccs-trl-stmt_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/nccs-api-not-found-metric-${var.comm-nccs-trl-stmt_environment}\" AND metric.labels.processType = monitoring.regex.full_match(\".*Employee.*\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "3600s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = (var.env == "np") ? "50" : "30"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "Employees Not Found",
    message          = "Application identified too many not found employees. Please verify.",
    number_of_events = (var.env == "np") ? "50 not found employees" : "30 not found employees",
    time_interval    = "1 hour",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt-email_send_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - Email Send Error - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - Email Send Error - ${var.comm-nccs-trl-stmt_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/nccs-api-email-send-error-metric-${var.comm-nccs-trl-stmt_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "600s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "3"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "Email Send Error",
    message          = "Application identified some email send errors. Please verify.",
    number_of_events = "3",
    time_interval    = "10 minutes",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt-file_retrieve_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - File Retrieve Error - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - File Retrieve Error - ${var.comm-nccs-trl-stmt_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/nccs-api-file-retrieve-error-metric-${var.comm-nccs-trl-stmt_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "3600s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "10"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "File Retrieve Error",
    message          = "Application identified some file retrieval errors. Please verify.",
    number_of_events = "10",
    time_interval    = "1 hour",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}

module "comm-nccs-trl-stmt-file_store_error_alert" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Corporate Stores Commission Statements - File Store Error - ${var.comm-nccs-trl-stmt_environment}"
  condition_display_name = "Corporate Stores Commission Statements - File Store Error - ${var.comm-nccs-trl-stmt_environment}"
  notif_id               = [data.google_monitoring_notification_channel.dl_nccs_support.name]
  filter                 = "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/nccs-api-file-store-error-metric-${var.comm-nccs-trl-stmt_environment}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "3600s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "5"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = true
  content = templatefile("${path.module}/cdo-comm-nccs-trl-stmt-notification-policy.md", {
    environment      = (var.env == "np") ? "Non-Production" : "Production",
    alert_message    = "File Store Error",
    message          = "Application identified some file upload errors. Please verify.",
    number_of_events = "5",
    time_interval    = "1 hour",
    nccs_gke_console = var.comm-nccs-trl-stmt_gke_console_url
  })
}