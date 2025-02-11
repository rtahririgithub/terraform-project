data "google_monitoring_notification_channel" "dl_ProductInventoryBridge" {
  display_name = "C3 Support Channel"
  project      = var.project_id
}

// [ProductInventoryBridge] API Error Counts Alert
module "pib_api-errors-above-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ProductInventoryBridge] API Error Counts Above 3 (${var.env})"
  condition_display_name = "[ProductInventoryBridge] API Error Counts Above 3 (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.dl_ProductInventoryBridge.name]
  content                = "Check ProductInventoryBridge API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: cust-om-order-mgmt  \n**Container**: product-inventory-bridge-api-${var.env}  "
  filter                 = "metric.type=\"external.googleapis.com/prometheus/http_server_requests_seconds_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"cust-om-order-mgmt\" metric.label.\"status\"=\"500\" resource.label.\"container_name\"=\"product-inventory-bridge-api-${var.env}\""
  threshold_value        = "3"
  duration               = "0s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_SUM"
  group_by_fields        = ["metric.label.status"]
  enabled                = "true"
}

// [ProductInventoryBridge] API Kubernetes CPU Limit Alert
module "pib_api-k8t-cpu-limit-above-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ProductInventoryBridge] API Kubernetes CPU Limit Above 0.95 (${var.env})"
  condition_display_name = "[ProductInventoryBridge] API Kubernetes CPU Limit Above 0.95 (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.dl_ProductInventoryBridge.name]
  content                = "Check ProductInventoryBridge API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: cust-om-order-mgmt  \n**Container**: product-inventory-bridge-api-${var.env}  "
  filter                 = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"cust-om-order-mgmt\" resource.label.\"container_name\"=\"product-inventory-bridge-api-${var.env}\""
  threshold_value        = "0.95"
  duration               = "60s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = "REDUCE_MAX"
  group_by_fields        = null
  enabled                = "true"
}

// [ProductInventoryBridge] API Kubernetes Container Alert
module "pib_api-k8t-container-restart_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ProductInventoryBridge] API Kubernetes Container Restart Greater Than 0 (${var.env})"
  condition_display_name = "[ProductInventoryBridge] API Kubernetes Container Restart Greater Than 0 (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.dl_ProductInventoryBridge.name]
  content                = "Check ProductInventoryBridge API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: cust-om-order-mgmt  \n**Container**: product-inventory-bridge-api-${var.env}  "
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"cust-om-order-mgmt\" resource.label.\"container_name\"=\"product-inventory-bridge-api-${var.env}\""
  threshold_value        = "0"
  duration               = "0s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_RATE"
  cross_series_reducer   = "REDUCE_SUM"
  group_by_fields        = ["resource.label.container_name"]
  enabled                = "true"
}

// [ProductInventoryBridge] API Kubernetes Memory Limit Alert
module "pib_api-k8t-mem-limit-above-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ProductInventoryBridge] API Kubernetes Memory Limit Above 0.95GiB (${var.env})"
  condition_display_name = "[ProductInventoryBridge] API Kubernetes Memory Limit Above 0.95GiB (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.dl_ProductInventoryBridge.name]
  content                = "Check ProductInventoryBridge API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: cust-om-order-mgmt  \n**Container**: product-inventory-bridge-api-${var.env}  "
  filter                 = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"cust-om-order-mgmt\" resource.label.\"container_name\"=\"product-inventory-bridge-api-${var.env}\" metric.label.\"memory_type\"=\"non-evictable\""
  threshold_value        = "0.95"
  duration               = "60s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = "REDUCE_MAX"
  group_by_fields        = null
  enabled                = "true"
}

// [ProductInventoryBridge] API Latency Alert - Done via resource instead of module call due to query language unsupported
resource "google_monitoring_alert_policy" "pib_alert_policy" {
  project               = var.project_id
  display_name          = "[ProductInventoryBridge] API Latency Over 0.5 Seconds Over 1 Min (${var.env})"
  notification_channels = [data.google_monitoring_notification_channel.dl_ProductInventoryBridge.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "Check ProductInventoryBridge API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: cust-om-order-mgmt  \n**Container**: product-inventory-bridge-api-${var.env}  "
  }

  conditions {
    display_name = "[ProductInventoryBridge] API Latency Over 0.5 Seconds Over 1 Min (${var.env})"

    condition_monitoring_query_language {
      query    = "{ t_0:\n    fetch k8s_container\n    | metric\n        'external.googleapis.com/prometheus/http_server_requests_seconds_sum'\n    | filter\n        (resource.namespace_name == 'cust-om-order-mgmt') && (metric.status == '200')\n        && (resource.container_name == 'product-inventory-bridge-api-${var.env}')\n    | align rate(1m)\n    | every 1m\n    | group_by [],\n        [value_http_server_requests_seconds_sum_aggregate:\n           aggregate(value.http_server_requests_seconds_sum)]\n; t_1:\n    fetch k8s_container\n    | metric\n        'external.googleapis.com/prometheus/http_server_requests_seconds_count'\n    | filter\n        (resource.namespace_name == 'cust-om-order-mgmt') && (metric.status == '200')\n        && (resource.container_name == 'product-inventory-bridge-api-${var.env}')\n    | align rate(1m)\n    | every 1m\n    | group_by [],\n        [value_http_server_requests_seconds_count_aggregate:\n           aggregate(value.http_server_requests_seconds_count)] }\n| join\n| value\n    [t_0_value_http_server_requests_seconds_sum_aggregate_div:\n       div(t_0.value_http_server_requests_seconds_sum_aggregate,\n         t_1.value_http_server_requests_seconds_count_aggregate)]\n| condition t_0_value_http_server_requests_seconds_sum_aggregate_div \u003e 0.5"
      duration = "60s"
      trigger {
        count = 1
      }
    }
  }
  enabled = "true"
}
