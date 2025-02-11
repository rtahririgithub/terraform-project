data "google_monitoring_notification_channel" "UCAR" {
  display_name = "UCAR Support Channel"
  project      = var.project_id
}

// [UCAR] API Error Counts Alert
module "ucar_api-errors-above-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[UCAR] API Error Counts Above 3 (${var.env})"
  condition_display_name = "[UCAR] API Error Counts Above 3 (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.UCAR.name]
  content                = "Check UCAR API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: datahub-ucir  \n**Container**: datahub-builder-${var.env}  "
  filter                 = "metric.type=\"external.googleapis.com/prometheus/http_server_requests_seconds_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"datahub-ucir\" metric.label.\"status\"=\"500\" resource.label.\"container_name\"=\"datahub-builder-${var.env}\""
  threshold_value        = "3"
  duration               = "0s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_SUM"
  group_by_fields        = ["metric.label.status"]
  enabled                = "true"
}

// [UCAR] API Kubernetes CPU Limit Alert
module "ucar_api-k8t-cpu-limit-above-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[UCAR] API Kubernetes CPU Limit Above 0.95 (${var.env})"
  condition_display_name = "[UCAR] API Kubernetes CPU Limit Above 0.95 (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.UCAR.name]
  content                = "Check UCAR API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: datahub-ucir  \n**Container**: datahub-builder-${var.env}  "
  filter                 = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"datahub-ucir\" resource.label.\"container_name\"=\"datahub-builder-${var.env}\""
  threshold_value        = "0.95"
  duration               = "60s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = "REDUCE_MAX"
  group_by_fields        = null
  enabled                = "true"
}

// [UCAR] API Kubernetes Container Alert
module "ucar_api-k8t-container-restart_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[UCAR] API Kubernetes Container Restart Greater Than 0 (${var.env})"
  condition_display_name = "[UCAR] API Kubernetes Container Restart Greater Than 0 (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.UCAR.name]
  content                = "Check UCAR API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: datahub-ucir  \n**Container**: datahub-builder-${var.env}  "
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"datahub-ucir\" resource.label.\"container_name\"=\"datahub-builder-${var.env}\""
  threshold_value        = "0"
  duration               = "0s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_RATE"
  cross_series_reducer   = "REDUCE_SUM"
  group_by_fields        = ["resource.label.container_name"]
  enabled                = "true"
}

// [UCAR] API Kubernetes Memory Limit Alert
module "ucar_api-k8t-mem-limit-above-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[UCAR] API Kubernetes Memory Limit Above 0.95GiB (${var.env})"
  condition_display_name = "[UCAR] API Kubernetes Memory Limit Above 0.95GiB (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.UCAR.name]
  content                = "Check UCAR API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: datahub-ucir  \n**Container**: datahub-builder-${var.env}  "
  filter                 = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"datahub-ucir\" resource.label.\"container_name\"=\"datahub-builder-${var.env}\" metric.label.\"memory_type\"=\"non-evictable\""
  threshold_value        = "0.95"
  duration               = "60s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = "REDUCE_MAX"
  group_by_fields        = null
  enabled                = "true"
}

// [UCAR] BigTable Storage Lower Bound Alert
module "ucar_bigtable-storage-below-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[UCAR] BigTable Storage Below 120GB (${var.env})"
  condition_display_name = "[UCAR] BigTable Storage Below 120GB (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.UCAR.name]
  content                = "Check the resources to determine cause of the under storage utilization under the following BigTable environment:  \n**Project:** ${var.datahub_projects["enterprise"]}  \n**Instance:** datahub-instance  \n**Clusters:** batch-cluster & live-cluster"
  filter                 = "metric.type=\"bigtable.googleapis.com/disk/bytes_used\" resource.type=\"bigtable_cluster\" resource.label.\"instance\"=\"datahub-instance\" resource.label.\"project_id\"=\"${var.datahub_projects["enterprise"]}\""
  comparison             = "COMPARISON_LT"
  threshold_value        = "120000000000"
  duration               = "0s"
  trigger_count          = "1"
  alignment_period       = "60s"
  cross_series_reducer   = null
  group_by_fields        = null
  per_series_aligner     = "ALIGN_MEAN"
  enabled                = "true"
}


// [UCAR] Bigtable Storage Upper Bound Alert
module "ucar_bigtable-storage-upper-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[UCAR] Bigtable Storage Over 4.5 TB (${var.env})"
  condition_display_name = "[UCAR] Bigtable Storage Over 4.5 TB (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.UCAR.name]
  content                = "Check the resources to determine cause of the huge storage utilization under the following BigTable environment:  \n**Project:** ${var.datahub_projects["enterprise"]}  \n**Instance:** datahub-instance  \n**Clusters:** batch-cluster & live-cluster"
  filter                 = "metric.type=\"bigtable.googleapis.com/disk/bytes_used\" resource.type=\"bigtable_cluster\" resource.label.\"project_id\"=\"${var.datahub_projects["enterprise"]}\" resource.label.\"instance\"=\"datahub-instance\""
  threshold_value        = "4500000000000"
  duration               = "0s"
  trigger_count          = "1"
  alignment_period       = "60s"
  cross_series_reducer   = null
  group_by_fields        = null
  per_series_aligner     = "ALIGN_MEAN"
  enabled                = "true"
}

// [UCAR] BigTable LIVE Cluster CPU Limit Alert
module "ucar_bigtable-live-cpu-limit-above-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[UCAR] BigTable LIVE Cluster CPU Over 0.7 (${var.env})"
  condition_display_name = "[UCAR] BigTable LIVE Cluster CPU Over 0.7 (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.UCAR.name]
  content                = "Check the resources to determine cause of the high CPU usage under the following BigTable environment:  \n**Project:** ${var.datahub_projects["enterprise"]}  \n**Instance:** datahub-instance  \n**Cluster:** live-cluster\n\n**NOTE**: Check whether there is any ongoing ingestion job that causes massive synchronization traffic from the batch-cluster."
  filter                 = "metric.type=\"bigtable.googleapis.com/cluster/cpu_load\" resource.type=\"bigtable_cluster\" resource.label.\"project_id\"=\"${var.datahub_projects["enterprise"]}\" resource.label.\"instance\"=\"datahub-instance\" resource.label.\"cluster\"=\"live-cluster\""
  threshold_value        = "0.7"
  duration               = "1800s"
  trigger_count          = "1"
  alignment_period       = "300s"
  cross_series_reducer   = null
  group_by_fields        = null
  per_series_aligner     = "ALIGN_MEAN"
  enabled                = "true"
}

// [UCAR] BigTable LIVE Cluster Latency Alert
module "ucar_bigtable-live-latency-threshold_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[UCAR] BigTable LIVE Cluster Latency Over 200ms (${var.env})"
  condition_display_name = "[UCAR] BigTable LIVE Cluster Latency Over 200ms (${var.env})"
  notif_id               = [data.google_monitoring_notification_channel.UCAR.name]
  content                = "Check the resources to determine cause of the high latency under the following BigTable environment:  \n**Project:** ${var.datahub_projects["enterprise"]}  \n**Instance:** datahub-instance  \n**Cluster:** live-cluster\n\n**NOTE**: Check whether there is any ongoing ingestion job that causes massive synchronization traffic from the batch-cluster."
  filter                 = "metric.type=\"bigtable.googleapis.com/server/latencies\" resource.type=\"bigtable_table\" resource.label.\"project_id\"=\"${var.datahub_projects["enterprise"]}\" resource.label.\"instance\"=\"datahub-instance\" resource.label.\"cluster\"=\"live-cluster\""
  threshold_value        = "200"
  duration               = "0s"
  trigger_count          = "1"
  alignment_period       = "300s"
  cross_series_reducer   = null
  group_by_fields        = null
  per_series_aligner     = "ALIGN_PERCENTILE_50"
  enabled                = "true"
}

// [UCAR] API Latency Alert - Done via resource instead of module call due to query language unsupported
resource "google_monitoring_alert_policy" "alert_policy" {
  project               = var.project_id
  display_name          = "[UCAR] API Latency Over 0.5 Seconds Over 1 Min (${var.env})"
  notification_channels = [data.google_monitoring_notification_channel.UCAR.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "Check UCAR API under the following Kubernetes Cluster:  \n**Project**: ${var.cio_gke_private_yul_001_project_id}  \n**Namespace**: datahub-ucir  \n**Container**: datahub-builder-${var.env}  "
  }

  conditions {
    display_name = "[UCAR] API Latency Over 0.5 Seconds Over 1 Min (${var.env})"

    condition_monitoring_query_language {
      query    = "{ t_0:\n    fetch k8s_container\n    | metric\n        'external.googleapis.com/prometheus/http_server_requests_seconds_sum'\n    | filter\n        (resource.namespace_name == 'datahub-ucir') && (metric.status == '200')\n        && (resource.container_name == 'datahub-builder-${var.env}')\n    | align rate(1m)\n    | every 1m\n    | group_by [],\n        [value_http_server_requests_seconds_sum_aggregate:\n           aggregate(value.http_server_requests_seconds_sum)]\n; t_1:\n    fetch k8s_container\n    | metric\n        'external.googleapis.com/prometheus/http_server_requests_seconds_count'\n    | filter\n        (resource.namespace_name == 'datahub-ucir') && (metric.status == '200')\n        && (resource.container_name == 'datahub-builder-${var.env}')\n    | align rate(1m)\n    | every 1m\n    | group_by [],\n        [value_http_server_requests_seconds_count_aggregate:\n           aggregate(value.http_server_requests_seconds_count)] }\n| join\n| value\n    [t_0_value_http_server_requests_seconds_sum_aggregate_div:\n       div(t_0.value_http_server_requests_seconds_sum_aggregate,\n         t_1.value_http_server_requests_seconds_count_aggregate)]\n| condition t_0_value_http_server_requests_seconds_sum_aggregate_div \u003e 0.5"
      duration = "60s"
      trigger {
        count = 1
      }
    }
  }
  enabled = "true"
}
