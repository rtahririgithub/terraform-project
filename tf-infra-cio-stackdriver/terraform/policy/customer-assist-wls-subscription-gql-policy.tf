variable "wls_subscription_gql_enable_alert" {
  description = "enable the alert"
  type        = bool
  default     = true
}

data "google_monitoring_notification_channel" "customer_assist_support" {
  display_name = "Customer Assist Support"
  project      = var.project_id
}

module "wls_subscription_gql_liveness_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[WLS Subscription GQL] [${upper(var.env)}] Liveness Probes"
  condition_display_name = "[WLS Subscription GQL] [${upper(var.env)}] Liveness Probes"
  notif_id               = [data.google_monitoring_notification_channel.customer_assist_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/wls_subscription_gql/liveness_probe\" AND resource.type=\"k8s_pod\" AND resource.label.\"namespace_name\"=\"dt-cons-customer-assist\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "300s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.wls_subscription_gql_enable_alert
}

module "wls_subscription_gql_critical_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[WLS Subscription GQL] [${upper(var.env)}]  50x Error Alert"
  condition_display_name = "[WLS Subscription GQL] [${upper(var.env)}]  50x Error Alert"
  content                = "Higher than expected amount of 50x errors in env: [${upper(var.env)}]. Please verify. \n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n"
  notif_id               = [data.google_monitoring_notification_channel.customer_assist_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/wls_subscription_gql/50x_error_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "180s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.wls_subscription_gql_enable_alert
}

module "wls_subscription_gql_40x_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[WLS Subscription GQL] [${upper(var.env)}]  40x Error Alert"
  condition_display_name = "[WLS Subscription GQL] [${upper(var.env)}]  40x Error Alert"
  content                = "Higher than expected amount of 40x errors in env: [${upper(var.env)}]. Please verify. \n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n"
  notif_id               = [data.google_monitoring_notification_channel.customer_assist_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/wls_subscription_gql/40x_error_count\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "180s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "10"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.wls_subscription_gql_enable_alert
}

module "wls_subscription_gql_critical_kong_accesstoken_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[WLS Subscription GQL] [${upper(var.env)}]  Kong Access Token Error Alert"
  condition_display_name = "[WLS Subscription GQL] [${upper(var.env)}]  Kong Access Token Error Alert"
  content                = "Higher than expected amount of errors in env: [${upper(var.env)}]. Please verify. \n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n"
  notif_id               = [data.google_monitoring_notification_channel.customer_assist_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/wls_subscription_gql/kong_connectivity\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.wls_subscription_gql_enable_alert
}
