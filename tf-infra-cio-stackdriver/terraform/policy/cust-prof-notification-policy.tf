variable "cust_prof_project_id" {
  type    = string
  default = "cio-cust-prof-np-f19f85"
}

variable "cust_prof_log_metrics_prefixes" {
  type    = list(string)
  default = ["stage", "it01", "it02", "it03", "prodlike"]
}

data "google_monitoring_notification_channel" "customer_profile_pubsub_support" {
  display_name = "Customer Profile Pubsub Support"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "customer_profile_dataflow_support" {
  display_name = "Customer Profile Dataflow Support"
  project      = var.project_id
}

module "cust_prof_unexpected_errors_alert_policy" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Unexpected Errors - ${each.key}"
  condition_display_name = "Customer profile - Unexpected Errors - ${each.key}"
  notif_id = [
    data.google_monitoring_notification_channel.customer_profile_pubsub_support.name
  ]
  filter               = "metric.type=\"logging.googleapis.com/user/cust-prof/unexpected-errors-${each.key}\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\""
  content              = "Unexpected Error. Please address these issues."
  trigger_count        = "1"
  threshold_value      = "0.0"
  per_series_aligner   = "ALIGN_SUM"
  cross_series_reducer = "REDUCE_NONE"
  alignment_period     = "60s"
  duration             = "0s"
  enabled              = "true"
}

module "cust_prof_http_gateway_error_alert_policy" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Http Gateway Error - ${each.key}"
  condition_display_name = "Customer profile - Http Gateway Error - ${each.key}"
  notif_id = [
    data.google_monitoring_notification_channel.customer_profile_pubsub_support.name
  ]
  filter               = "metric.type=\"logging.googleapis.com/user/cust-prof/http-gateway-error-${each.key}\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\""
  content              = "Http gateway error. Please address these issues."
  trigger_count        = "1"
  threshold_value      = "3"
  per_series_aligner   = "ALIGN_SUM"
  cross_series_reducer = "REDUCE_SUM"
  alignment_period     = "360s"
  duration             = "0s"
  enabled              = "true"
}

module "cust_prof_http_gateway_internal_server_error_alert_policy" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Http Gateway Internal Server Error - ${each.key}"
  condition_display_name = "Customer profile - Http Gateway Internal Server Error - ${each.key}"
  notif_id = [
    data.google_monitoring_notification_channel.customer_profile_pubsub_support.name
  ]
  filter               = "metric.type=\"logging.googleapis.com/user/cust-prof/http-gateway-internal-server-error-${each.key}\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\""
  content              = "Http gateway internal sever error. Please address these issues."
  trigger_count        = "1"
  threshold_value      = "0"
  per_series_aligner   = "ALIGN_SUM"
  cross_series_reducer = "REDUCE_NONE"
  alignment_period     = "60s"
  duration             = "0s"
  enabled              = "true"
}

module "cust_prof_event_critical_server_error_alert_policy" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Event critical error - ${each.key}"
  condition_display_name = "Customer profile - Event critical error - ${each.key}"
  notif_id = [
    data.google_monitoring_notification_channel.customer_profile_pubsub_support.name
  ]
  filter               = "metric.type=\"logging.googleapis.com/user/cust-prof/event-critical-server-error-${each.key}\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\""
  content              = "Event critical error. Please address these issues."
  trigger_count        = "1"
  threshold_value      = "0"
  per_series_aligner   = "ALIGN_SUM"
  cross_series_reducer = "REDUCE_NONE"
  alignment_period     = "60s"
  duration             = "0s"
  enabled              = "true"
}


module "cust_prof_data_flow_unhandled_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Dataflow Unhandled errors"
  condition_display_name = "Customer profile - Dataflow Unhandled errors"
  notif_id = [
    data.google_monitoring_notification_channel.customer_profile_pubsub_support.name,
    data.google_monitoring_notification_channel.customer_profile_dataflow_support.name
  ]
  filter               = "metric.type=\"logging.googleapis.com/user/cust-prof/dataflow-unhandled-error\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=\"${var.cust_prof_project_id}\""
  content              = "Dataflow unhandled errors. Please address these issues."
  trigger_count        = "1"
  threshold_value      = "0"
  per_series_aligner   = "ALIGN_SUM"
  cross_series_reducer = "REDUCE_NONE"
  alignment_period     = "60s"
  duration             = "0s"
  enabled              = "true"
}


module "cust_prof_dataflow_job_failure" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Dataflow job fail alert"
  condition_display_name = "Customer profile - Dataflow job fail alert"
  notif_id = [
    data.google_monitoring_notification_channel.customer_profile_pubsub_support.name,
    data.google_monitoring_notification_channel.customer_profile_dataflow_support.name
  ]
  filter               = "metric.type=\"dataflow.googleapis.com/job/is_failed\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=\"${var.cust_prof_project_id}\""
  content              = "Dataflow job failed. Please verify."
  trigger_count        = "1"
  threshold_value      = "0"
  per_series_aligner   = "ALIGN_MAX"
  cross_series_reducer = "REDUCE_SUM"
  alignment_period     = "120s"
  duration             = "0s"
  enabled              = "true"
}


module "cust_prof_dataflow_many_errors" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Dataflow max errors count"
  condition_display_name = "Customer profile - Dataflow max errors count"
  notif_id = [
    data.google_monitoring_notification_channel.customer_profile_dataflow_support.name
  ]
  filter               = "metric.type=\"logging.googleapis.com/user/cust-prof/dataflow-errors-count\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=\"${var.cust_prof_project_id}\""
  content              = "Dataflow has more errors than expected. Please address these issues."
  trigger_count        = "1"
  threshold_value      = "20"
  per_series_aligner   = "ALIGN_SUM"
  cross_series_reducer = "REDUCE_SUM"
  alignment_period     = "120s"
  duration             = "0s"
  enabled              = "true"
}


module "cust_prof_performance_degradation_alert" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - High execution time for http requests - ${each.key}"
  condition_display_name = "Customer profile - High execution time for http requests - ${each.key}"
  notif_id = [
    data.google_monitoring_notification_channel.customer_profile_dataflow_support.name
  ]
  filter               = "metric.type=\"logging.googleapis.com/user/cust-prof/http-request-execution-time-${each.key}\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\""
  content              = "Http requests have an execution time higher than expected."
  trigger_count        = "2"
  threshold_value      = "30000"
  per_series_aligner   = "ALIGN_SUM"
  cross_series_reducer = "REDUCE_PERCENTILE_95"
  alignment_period     = "43200s"
  duration             = "0s"
  enabled              = "true"
}


module "cust_prof_container_restart_alert" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Container keeps restarting - ${each.key}"
  condition_display_name = "Customer profile - Container keeps restarting - ${each.key}"
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"cust-cust-prof\" resource.label.\"container_name\"=\"cust-prof-service-api-${each.key}-${var.env}\""
  notif_id               = [data.google_monitoring_notification_channel.customer_profile_pubsub_support.name]
  content                = "Application keeps restarting. Please address this issue."
  trigger_count          = "1"
  threshold_value        = "10"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_MAX"
  alignment_period       = "43200s"
  duration               = "600s"
  enabled                = "true"
}

module "cust_prof_tm_consumer_not_working_alert" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - TM billing feed not working - ${each.key}"
  condition_display_name = "Customer profile - TM billing feed not working - ${each.key}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/oldest_unacked_message_age\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.cust_prof_project_id}\" resource.label.\"subscription_id\"=\"cust-prof-service-tm-billing-feeds-v1${var.env == "np" ? join("", ["-", var.env, "-", each.key]) : ""}.bcp-subscription\""
  notif_id               = [data.google_monitoring_notification_channel.customer_profile_pubsub_support.name]
  content                = "Application doesn't consume tm messages. Please verify"
  trigger_count          = "1"
  threshold_value        = "86400"
  per_series_aligner     = "ALIGN_MAX"
  cross_series_reducer   = "REDUCE_MAX"
  alignment_period       = "43200s"
  duration               = "0s"
  enabled                = "true"
}

// #################### Core Job ###########################

module "cust_prof_core_job_unhandled_errors_alert" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Core job unhandled errors - ${each.key}"
  condition_display_name = "Customer profile - Core job unhandled errors - ${each.key}"
  filter                 = "metric.type=\"logging.googleapis.com/user/cust-cust-prof-core-job-unhandled-errors-${each.key}\" resource.type=\"k8s_container\""
  notif_id               = [data.google_monitoring_notification_channel.customer_profile_pubsub_support.name]
  content                = "Unhandled errors in core job."
  trigger_count          = "1"
  threshold_value        = "0"
  per_series_aligner     = "ALIGN_SUM"
  cross_series_reducer   = "REDUCE_SUM"
  alignment_period       = "60s"
  duration               = "0s"
  enabled                = "true"
}

module "cust_prof_core_job_execution_errors_alert" {
  for_each               = toset(var.cust_prof_log_metrics_prefixes)
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Customer profile - Core job execution errors - ${each.key}"
  condition_display_name = "Customer profile - Core job execution errors - ${each.key}"
  filter                 = "metric.type=\"logging.googleapis.com/user/cust-cust-prof-core-job-execution-errors-${each.key}\" resource.type=\"k8s_container\""
  notif_id               = [data.google_monitoring_notification_channel.customer_profile_pubsub_support.name]
  content                = "More than one job failed in a short period of time"
  trigger_count          = "1"
  threshold_value        = "3"
  per_series_aligner     = "ALIGN_SUM"
  cross_series_reducer   = "REDUCE_SUM"
  alignment_period       = "3600s"
  duration               = "0s"
  enabled                = "true"
}