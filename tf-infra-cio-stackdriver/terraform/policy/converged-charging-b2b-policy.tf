variable "converged_charging_enable_alert" {
  description = "enable the alert"
  type        = bool
  default     = false
}

variable "converged_charging_project_id" {
  description = "converged-charging-b2b_project id"
  type        = string
  default     = ""
}

variable "converged_charging_database_id" {
  description = "database id for converged charging"
  type        = string
  default     = ""
}


locals {
  converged_charging_notification_name = "Business To Business Wireless Usage Summary Support E-mail"
  converged_charging_env               = var.env == "np" ? "np" : "pr"
}


data "google_monitoring_notification_channel" "converged_charging_pub_sub" {
  display_name = local.converged_charging_notification_name
  project      = var.project_id
}


module "converged_charging_pubsub_subscription_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Converged Charging TDR Pubsub] [${var.env}] Collection unacked messages"
  condition_display_name = "Converged Charging TDR Pubsub Collection queue over threshold"
  notif_id               = [data.google_monitoring_notification_channel.converged_charging_pub_sub.name]
  content                = "## Pubsub subscription unacked message over the threshold\n This could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\n"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.converged_charging_project_id}\" resource.label.\"subscription_id\"=monitoring.regex.full_match(\"MZ_TDR.*\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "5000"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.converged_charging_enable_alert
}


module "converged_charging_pubsub_subscription_edr_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Converged Charging EDR Pubsub] [${var.env}] Collection unacked messages"
  condition_display_name = "Converged Charging EDR Pubsub Collection queue over threshold"
  notif_id               = [data.google_monitoring_notification_channel.converged_charging_pub_sub.name]
  content                = "## Pubsub subscription unacked message over the threshold\n This could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\n"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.converged_charging_project_id}\" resource.label.\"subscription_id\"=monitoring.regex.full_match(\"MZ_EDR.*\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "5000"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.converged_charging_enable_alert
}


module "converged_charging_postgres_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Converged Charging Postgres CPU Utilization] [${var.env}] CPU utilization for CloudSQL database: ${var.converged_charging_database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.converged_charging_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.converged_charging_pub_sub.name]
  content                = "CPU Utilization for CloudSQL database: ${var.converged_charging_database_id} is at 50%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.converged_charging_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.5"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.converged_charging_enable_alert
}

resource "google_monitoring_alert_policy" "converged_charging_redis_cache_health" {
  project               = var.project_id
  display_name          = "[Converged Charging Redis:RED] [${var.env}] Redis primary node is down"
  notification_channels = [data.google_monitoring_notification_channel.converged_charging_pub_sub.name]
  combiner              = "OR"

  conditions {
    display_name = "Redis is down"
    condition_absent {
      filter   = "metric.type=\"redis.googleapis.com/server/uptime\" resource.type=\"redis_instance\" resource.label.\"project_id\"=\"${var.converged_charging_project_id}\" metric.label.\"role\"=\"primary\""
      duration = "180s"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "## Redis Health Information Absent\n Redis primary node is down. Please go to the console making sure it has failed over to the replica node and start running.\n Console url: https://console.cloud.google.com/memorystore/redis/instances?project=${var.ecp_project_id}\n Please also double check applications connecting to Redis are still able to establish the connection."
  }

}

module "converged_charging_cloudsql_server_down_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Converged Charging CloudSQL] [${var.env}] CloudSQL database: ${var.converged_charging_database_id} is down"
  condition_display_name = "${var.converged_charging_database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.converged_charging_pub_sub.name]
  content                = "CloudSQL database: ${var.converged_charging_database_id} is down. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.converged_charging_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = var.converged_charging_enable_alert
}

module "converged_charging_tdr_low_message_volume_alert_policy" {
  count = var.env == "NP" ? 0 : 1

  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Converged Charging Pubsub] [${var.env}] TDR Pubsub Low Message Volume"
  condition_display_name = "[Converged Charging TDR Pubsub] [${var.env}] message count below threshold [1]"
  notif_id               = [data.google_monitoring_notification_channel.converged_charging_pub_sub.name]
  content                = "Converged Charging TDR Pubsub message count is below threshold (i.e. **less than 1 message for past 5 minutes**)."
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/sent_message_count\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.converged_charging_project_id}\" metadata.system_labels.\"topic_id\"=monitoring.regex.full_match(\"B2B_Data_TDR_external\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = var.converged_charging_enable_alert
}



