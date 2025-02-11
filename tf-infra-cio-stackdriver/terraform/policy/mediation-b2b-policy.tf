variable "mediation-b2b_database_id" {
  description = "database id for mediation-b2b"
  type        = string
}

variable "mediation-b2b_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "mediation-b2b_project_id" {
  description = "mediation-b2b_project id"
  type        = string
}


locals {
  mediation-b2b_notification_name = format("Mediation-B2B_GCP_Support-%s Email", upper(var.env))
  mediation-b2b_personal_name     = format("Mediation-Personal-Support-%s Email", upper(var.env))
}


data "google_monitoring_notification_channel" "mediationmgmt" {
  display_name = local.mediation-b2b_notification_name
  project      = var.project_id
}

data "google_monitoring_notification_channel" "mediationpersonal" {
  display_name = local.mediation-b2b_personal_name
  project      = var.project_id
}

module "mediation-b2b_exception_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-b2b][${var.env}] mediation-BEH_exception"
  condition_display_name = "[Mediation-b2b][${var.env}] mediation-BEH_exception"
  notif_id               = [data.google_monitoring_notification_channel.mediationmgmt.name]
  content                = "mediation Exception occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/mediation/b2b/BEH_Permanent_Errors\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "5"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mediation-b2b_enable_alert
}

module "mediation-b2b_peh_exception_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-b2b][${var.env}] mediation-PEH-exception"
  condition_display_name = "[Mediation-b2b][${var.env}] mediation-PEH_exception"
  notif_id               = [data.google_monitoring_notification_channel.mediationmgmt.name]
  content                = "mediation PEH Exception occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/mediation/b2b/PEH_Permanent_Errors\" AND resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mediation-b2b_enable_alert
}

module "mediation-b2b_cloudsql_server_down_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-B2B CloudSQL] [${var.env}] CloudSQL database: ${var.mediation-b2b_database_id} is down"
  condition_display_name = "${var.mediation-b2b_database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.mediationmgmt.name]
  content                = "CloudSQL database: ${var.mediation-b2b_database_id} is down. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.mediation-b2b_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = var.mediation-b2b_enable_alert
}

module "mediation-b2b_cloudsql_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-B2B CloudSQL] [${var.env}] CPU utilization for CloudSQL database: ${var.mediation-b2b_database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.mediation-b2b_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.mediationmgmt.name]
  content                = "CPU Utilization for CloudSQL database: ${var.mediation-b2b_database_id} is at 80%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.mediation-b2b_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mediation-b2b_enable_alert
}

module "mediation-b2b_pubsub_subscription_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-B2B Pubsub] [${var.env}] Collection unacked messages"
  condition_display_name = "B2B Pubsub Collection queue over threshold"
  notif_id               = [data.google_monitoring_notification_channel.mediationmgmt.name]
  content                = "## Pubsub subscription unacked message over the threshold\n This could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\n"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.mediation-b2b_project_id}\" resource.label.\"subscription_id\"=monitoring.regex.full_match(\"B2B.Maint_EDR_collection.input|B2B.Data_TDR_collection.input|\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "60"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mediation-b2b_enable_alert
}

module "mediation-b2b_pubsub_collection_idle_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-B2B Pubsub] [${var.env}] TDR Collection idle"
  condition_display_name = "B2B Pubsub Collection queue under threshold"
  notif_id               = [data.google_monitoring_notification_channel.mediationmgmt.name]
  content                = "## Pubsub subscription messages under the threshold\n This could caused by not enough files being transferred from on-premises mediation.\n Please confirm if MZ and NiFi are running.\n"
  filter                 = "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\" resource.label.\"project_id\"=\"${var.mediation-b2b_project_id}\" resource.label.\"topic_id\"=monitoring.regex.full_match(\"B2B.Data_TDR_collection\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "1800s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "5"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "900s"
  enabled                = var.env == "np" ? false : true
}

module "mediation-b2b_pubsub_subscription_alert_policy_DB" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-B2B Pubsub] [${var.env}] DB unacked messages"
  condition_display_name = "B2B Pubsub DB Load queue over threshold"
  notif_id               = [data.google_monitoring_notification_channel.mediationmgmt.name]
  content                = "## Pubsub subscription unacked message over the threashold\n This could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\n"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.mediation-b2b_project_id}\" resource.label.\"subscription_id\"=monitoring.regex.full_match(\"camp.audit.AuditRow|B2B.Data_TDR_Storage.b2bStorage|B2B.Maint_EDR_Storage.b2bStorage\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "100"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mediation-b2b_enable_alert
}

module "mediation-b2b_pubsub_subscription_alert_policy_Stream" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Mediation-B2B Pubsub] [${var.env}] Streaming unacked messages"
  condition_display_name = "Streaming Pubsub queue over threshold"
  notif_id               = [data.google_monitoring_notification_channel.mediationmgmt.name]
  content                = "## Pubsub subscription unacked message over the threashold\n This could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\n"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.mediation-b2b_project_id}\" resource.label.\"subscription_id\"=monitoring.regex.full_match(\"B2B.batch_Maint_EDR_to_stream.b2bmbTOStr|B2B.batch_Data_TDR_to_stream.b2bmbTOStr\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "100"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mediation-b2b_enable_alert
}