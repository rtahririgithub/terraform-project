variable "database_id" {
  description = "database id for communication-message"
  type        = string
}

variable "enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "ecp_project_id" {
  description = "ecp_project id"
  type        = string
}

variable "wnp_processor_log_url" {
  description = "wnp processor log url"
  type        = string
}

variable "custbill_retrieval_log_url" {
  description = "Custbill retrieval(eBill) log url"
  type        = string
}

variable "message_publisher_service_url" {
  description = "message_publisher_service_url"
  type        = string
  default     = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/message-publisher-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
}

variable "usage_distribution_subscriber_service_url" {
  description = "usage_distribution_subscriber_service_url"
  type        = string
  default     = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-distribution-subscriber-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
}

variable "usage_policy_subscriber_service_url" {
  description = "usage_policy_subscriber_service_url"
  type        = string
  default     = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-policy-subscriber-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
}

variable "usage_policy_bc_subscriber_service_url" {
  description = "usage_policy_bc_subscriber_service_url"
  type        = string
  default     = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-policy-bc-subscriber-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
}

variable "gcp_pubsub_topic_data_usage_url" {
  description = "gcp_pubsub_topic_data_usage_url"
  type        = string
  default     = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage?project=cio-notification-pr-64911f"
}

variable "gcp_pubsub_topic_data_usage_policy_sub_url" {
  description = "gcp_pubsub_topic_data_usage_policy_sub_url"
  type        = string
  default     = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.policy.sub?project=cio-notification-pr-64911f"
}

variable "gcp_pubsub_topic_data_usage_delivery_url" {
  description = "gcp_pubsub_topic_data_usage_delivery_url"
  type        = string
  default     = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage.delivery?project=cio-notification-pr-64911f"
}

variable "gcp_pubsub_topic_data_usage_delivery_sub_url" {
  description = "gcp_pubsub_topic_data_usage_delivery_sub_url"
  type        = string
  default     = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.delivery.sub?project=cio-notification-pr-64911f"
}

variable "gcp_pubsub_topic_data_usage_bc_delivery_url" {
  description = "gcp_pubsub_topic_data_usage_bc_delivery_url"
  type        = string
  default     = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage.bc.delivery?project=cio-notification-pr-64911f"
}

variable "gcp_pubsub_topic_data_usage_bc_delivery_sub_url" {
  description = "gcp_pubsub_topic_data_usage_bc_delivery_sub_url"
  type        = string
  default     = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.bc.delivery.sub?project=cio-notification-pr-64911f"
}

variable "usage_preference_service_url" {
  description = "usage_preference_service_url"
  type        = string
  default     = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-preference-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
}

variable "usage_customer_info_service_url" {
  description = "usage_customer_info_service_url"
  type        = string
  default     = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-customer-info-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
}

data "google_monitoring_notification_channel" "ECP_slack" {
  display_name = "ECP Slack Email"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "OnlineMz_Support_DL" {
  display_name = "OnlineMz Support DL"
  project      = var.project_id
}

locals {
  usage_flow_consumer      = "OnlineMz -> [Message Publisher](${var.message_publisher_service_url}) -> [GCP Pubsub Topic(data.usage)](${var.gcp_pubsub_topic_data_usage_url}) -> [GCP Pubsub Subscription(data.usage.policy.sub)](${var.gcp_pubsub_topic_data_usage_policy_sub_url}) -> [usage-distribution-subscriber](${var.usage_distribution_subscriber_service_url}) -> [GCP Pubsub Topic(data.usage.delivery)](${var.gcp_pubsub_topic_data_usage_delivery_url}) -> [GCP Pubsub Subscription(data.usage.delivery.sub)](${var.gcp_pubsub_topic_data_usage_delivery_sub_url}) -> [usage-policy-subscriber](${var.usage_policy_subscriber_service_url}) -> Communication API V2"
  usage_flow_business_corp = "OnlineMz -> [Message Publisher](${var.message_publisher_service_url}) -> [GCP Pubsub Topic(data.usage)](${var.gcp_pubsub_topic_data_usage_url}) -> [GCP Pubsub Subscription(data.usage.policy.sub)](${var.gcp_pubsub_topic_data_usage_policy_sub_url}) -> [usage-distribution-subscriber](${var.usage_distribution_subscriber_service_url}) -> [GCP Pubsub Topic(data.usage.bc.delivery)](${var.gcp_pubsub_topic_data_usage_bc_delivery_url}) -> [GCP Pubsub Subscription(data.usage.bc.delivery.sub)](${var.gcp_pubsub_topic_data_usage_bc_delivery_sub_url}) -> [usage-policy-bc-subscriber](${var.usage_policy_bc_subscriber_service_url})) -> Communication API V2"
  data_usage_flow          = "\n\nConsumer Traffic Flow: ${local.usage_flow_consumer}.\n\nBusiness/Corp Traffic Flow: ${local.usage_flow_business_corp}."
}

module "ecp_cloudsql_server_up_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CloudSQL] [${var.env}] CloudSQL database: ${var.database_id} is down"
  condition_display_name = "${var.database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "CloudSQL database: ${var.database_id} is down. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "0s"
  enabled                = "true"
}

module "ecp_cloudsql_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CloudSQL] [${var.env}] CPU utilization for CloudSQL database: ${var.database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "CPU Utilization for CloudSQL database: ${var.database_id} is at 20%. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.5"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.enable_alert
}

module "ecp_cloudsql_memory_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CloudSQL] [${var.env}] Memory utilization for CloudSQL database: ${var.database_id}"
  condition_display_name = "Memory utilization for CloudSQL database: ${var.database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Memory Utilization for CloudSQL database: ${var.database_id} is at 50%. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.5"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.enable_alert
}

module "ecp_cloudsql_active_connection_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CloudSQL] [${var.env}] Active Connnections for CloudSQL database: ${var.database_id}"
  condition_display_name = "Active Connnections for CloudSQL database: ${var.database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Active Connnections for CloudSQL database: ${var.database_id} is active normal. Please address these issues."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "40"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = var.enable_alert
}

module "ecp_pubsub_bigquery_message_recorder_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] PubSub to BigQuery message.recorder Unacked Messages"
  condition_display_name = "[ECP Pubsub] PubSub message.recorder topic 225 unacked messages in 5 minutes"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "message.recorder.bq.subscription has not acked messages for 5 minutes.  Check Dataflow job message-recorder-ps-bq-job to see if Status is in running state.\n\nIf not running, rebuild through Terraform with label data-analytics.${var.env}.vx.x.x then determine cause of failure.\n\nSubscription has 1 day retention for Dataflow job restoration."
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"message.recorder.bq.subscription\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "225"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = "true"
}

module "ecp_pubsub_bigquery_message_reply_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] PubSub to BigQuery message.reply Unacked Messages"
  condition_display_name = "[ECP Pubsub] PubSub message.reply topic 10 unacked messages in 5 minutes"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "message.reply.bq.subscription has not acked messages for 5 minutes.  Check Dataflow job message-reply-ps-bq-job to see if Status is in running state.\n\nIf not running, rebuild through Terraform with label data-analytics.${var.env}.vx.x.x then determine cause of failure.\n\nSubscription has 1 day retention for Dataflow job restoration."
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"message.reply.bq.subscription\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "10"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = "true"
}

module "ecp_dataflow_message_recorder_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Dataflow] Dataflow message.recorder is down"
  condition_display_name = "[ECP Dataflow] Dataflow job message-recorder-ps-bq-job has been down in the last minute"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "message-recorder-ps-bq-job has been down in the last minute.  Check Dataflow job message-recorder-ps-bq-job to see if Status is in running state.\n\nIf not running, rebuild through Terraform with label data-analytics.${var.env}.vx.x.x then determine cause of failure.\n\nSubscription has 1 day retention for Dataflow job restoration."
  filter                 = "metric.type=\"dataflow.googleapis.com/job/is_failed\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"job_name\"=\"message-recorder-ps-bq-job\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = "true"
}

#wnp pubsub subscription
module "ecp_wnp_pubsub_subscription_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] WNP Pubsub unacked message"
  condition_display_name = "WNP Pubsub subscription unacked message count over threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "## Pubsub subscription unacked message over the threashold\nThis could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\nFor consumer running on GKE, run \"kubectl scale deployment deploymentName --replicas=5\" to create more instances"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=monitoring.regex.full_match(\".*wnp.*\")"
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "20"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = var.enable_alert
}

#database presistence subscription
module "ecp_recorder_pubsub_subscription_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] Message Recorder Pubsub unacked message"
  condition_display_name = "Message Recorder Pubsub subscription unacked message count over threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "## Pubsub subscription unacked message over the threashold\nThis could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\nFor consumer running on GKE, run \"kubectl scale deployment deploymentName --replicas=5\" to create more instances"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"message.recorder.subscription\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "500"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = var.enable_alert
}

#DUENS entry point topic(usage distribution service picks up traffic sent by OnlineMZ, processes and posts to different topics based on account type)
module "ecp_pubsub_data_usage_low_message_volume_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage Low Message Volume"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage message count below threshold"
  #notif_id               = [data.google_monitoring_notification_channel.ECP.name, data.google_monitoring_notification_channel.ECP_slack.name, data.google_monitoring_notification_channel.OnlineMz_Support_DL.name]
  notif_id = [data.google_monitoring_notification_channel.OnlineMz_Support_DL.name]

  content              = "Subscription: data.usage.policy.sub message count is below threshold (i.e. **less than 1 message for past 1 hour**).\n\nCheck [message-publisher](${var.message_publisher_service_url}) to ensure it is up running and if there is any issue to publish messages to data.usage.${local.data_usage_flow}"
  filter               = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.policy.sub\""
  policy_comb          = "OR"
  per_series_aligner   = "ALIGN_MAX"
  alignment_period     = "60s"
  cross_series_reducer = "REDUCE_NONE"
  threshold_value      = "1"
  comparison           = "COMPARISON_LT"
  trigger_count        = "1"
  duration             = "3600s"
  enabled              = var.enable_alert
}

module "ecp_pubsub_data_usage_high_message_volume_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage High Message Volume"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage message count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Subscription: data.usage.policy.sub message count is above threshold (i.e. **more than 200 messages for past 20 minutes**).\n\n Check [usage-distribution-subscriber](${var.usage_distribution_subscriber_service_url}) to ensure it is up running and if there is any issue to consume messages from data.usage.${local.data_usage_flow}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.policy.sub\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "200"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "1200s"
  enabled                = "true"
}

module "ecp_pubsub_data_usage_dead_letter_message_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.dead.letter Rejected Message"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.dead.letter message count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Subscription: data.usage.dead.letter.sub message count is above threshold (i.e. **1 or more messages for past 20 minutes**).\n\n Check [usage-distribution-subscriber](${var.usage_distribution_subscriber_service_url}) if there is any issue while connecting to downstream services.${local.data_usage_flow}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.dead.letter.sub\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "1200s"
  enabled                = "true"
}

#DUENS topic for Consumer traffic(usage policy service picks up traffic preprocessed by usage distribution service)
module "ecp_pubsub_data_usage_consumer_low_message_volume_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.delivery CONSUMER Low Message Volume"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.delivery CONSUMER message count below threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Subscription: data.usage.delivery.sub message count is below threshold (i.e. **less than 1 message for past 1 hour**).\n\n Check [usage-distribution-subscriber](${var.usage_distribution_subscriber_service_url}) to ensure it is up running and if there is any issue to publish messages to data.usage.delivery.${local.data_usage_flow}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.delivery.sub\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "3600s"
  enabled                = var.enable_alert
}

module "ecp_pubsub_data_usage_consumer_high_message_volume_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.delivery CONSUMER High Message Volume"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.delivery CONSUMER message count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Subscription: data.usage.delivery.sub message count is above threshold (i.e. **more than 60 messages for past 20 minutes**).\n\n Check [usage-policy-subscriber](${var.usage_policy_subscriber_service_url}) to ensure it is up running and if there is any issue to consume messages from data.usage.delivery.${local.data_usage_flow}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.delivery.sub\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "60"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "1200s"
  enabled                = "true"
}

module "ecp_pubsub_data_usage_consumer_dead_letter_message_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.delivery.dead.letter CONSUMER Rejected Message"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.delivery.dead.letter CONSUMER message count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Subscription: data.usage.delivery.dead.letter.sub message count is above threshold (i.e. **1 or more messages for past 20 minutes**).\n\n Check [usage-policy-subscriber](${var.usage_policy_subscriber_service_url})) if there is any issue to connect to downstream services.${local.data_usage_flow}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.delivery.dead.letter.sub\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "1200s"
  enabled                = "true"
}

#DUENS topic for Business/Corporate traffic(usage policy service picks up traffic preprocessed by usage distribution service)
module "ecp_pubsub_data_usage_bc_low_message_volume_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.bc.delivery BUSINESS/CORPORATE Low Message Volume"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.bc.delivery BUSINESS/CORPORATE message count below threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Subscription: data.usage.bc.delivery.sub message count is below threshold (i.e. **less than 1 message for past 1 hour**).\n\n Check [usage-distribution-subscriber](${var.usage_distribution_subscriber_service_url}) to ensure it is up running and if there is any issue to publish messages to data.usage.bc.delivery.${local.data_usage_flow}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.bc.delivery.sub\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "3600s"
  enabled                = var.enable_alert
}

module "ecp_pubsub_data_usage_bc_high_message_volume_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.bc.delivery BUSINESS/CORPORATE High Message Volume"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.bc.delivery BUSINESS/CORPORATE message count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Subscription: data.usage.bc.delivery.sub message count is above threshold (i.e. **more than 100 messages for past 20 minutes**).\n\n Check [usage-policy-bc-subscriber](${var.usage_policy_bc_subscriber_service_url})) to ensure it is up running and if there is any issue to consume messages from data.usage.bc.delivery.${local.data_usage_flow}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.bc.delivery.sub\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "100"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "1200s"
  enabled                = "true"
}

module "ecp_pubsub_data_usage_bc_dead_letter_message_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.delivery.dead.letter BUSINESS/CORPORATE Rejected Message"
  condition_display_name = "[ECP Pubsub] [${var.env}] DUENS Topic data.usage.delivery.dead.letter BUSINESS/CORPORATE message count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "Subscription: data.usage.delivery.dead.letter.sub message count is above threshold (i.e. **1 or more messages for past 20 minutes**).\n\n Check [usage-policy-bc-subscriber](${var.usage_policy_bc_subscriber_service_url}) if there is any issue to connect to downstream services.${local.data_usage_flow}"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"data.usage.delivery.dead.letter.sub\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MAX"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "1200s"
  enabled                = "true"
}

#Alert when GCP DUENS containers restart.
module "ecp_notify_duens_container_restart_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Container Restarts"
  condition_display_name = "[GCP DUENS] [${var.env}] one or more containers have restarted"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS Container:($${resource.labels.container_name}) restarted. Please verify the containers status in [GKE Console](${var.gke_console_url})."
  filter                 = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"notify-communication\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\" resource.label.\"container_name\": monitoring.regex.full_match(\"^usage-(bigquery-adapter|config|customer-info|distribution-subscriber|policy-bc-subscriber|policy-subscriber|preference).*\")"
  threshold_value        = "0"
  duration               = "0s"
  trigger_count          = "1"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_RATE"
  cross_series_reducer   = "REDUCE_SUM"
  group_by_fields        = ["resource.label.container_name"]
  enabled                = "true"
}

#GCP DUENS downstream service alert: WCPMS retry errors
module "ecp_notify_duens_downstream_wcpms_retry_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: WCPMS Retry Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: WCPMS causing retry errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-preference** encountered retry errors above permissible threshold within past 10 minutes, while trying to talk to downstream WCPMS service. This could be because requests are timing out due to slowness or unavailability.\n\nCheck usage-preference service logs [here](${var.usage_preference_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/wcpms/retry_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: WCPMS server errors
module "ecp_notify_duens_downstream_wcpms_server_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: WCPMS Server Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: WCPMS causing server errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-preference** encountered server errors above permissible threshold within past 10 minutes, while trying to talk to downstream WCPMS service. This could be because of bad requests, unhandled exceptions, etc.\n\nCheck usage-preference service logs [here](${var.usage_preference_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/wcpms/server_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: WPS retry errors
module "ecp_notify_duens_downstream_wps_retry_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: WPS Retry Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: WPS causing retry errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-preference** encountered retry errors above permissible threshold within past 10 minutes, while trying to talk to downstream WPS service. This could be because requests are timing out due to slowness or unavailability.\n\nCheck usage-preference service logs [here](${var.usage_preference_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/wps/retry_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: WPS server errors
module "ecp_notify_duens_downstream_wps_server_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: WPS Server Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: WPS causing server errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-preference** encountered server errors above permissible threshold within past 10 minutes, while trying to talk to downstream WPS service. This could be because of bad requests, unhandled exceptions, etc.\n\nCheck usage-preference service logs [here](${var.usage_preference_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/wps/server_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: ConsentAPI retry errors
module "ecp_notify_duens_downstream_consentapi_retry_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: ConsentAPI Retry Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: ConsentAPI causing retry errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-preference** encountered retry errors above permissible threshold within past 10 minutes, while trying to talk to downstream ConsentAPI service. This could be because requests are timing out due to slowness or unavailability.\n\nCheck usage-preference service logs [here](${var.usage_preference_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/consentapi/retry_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: ConsentAPI server errors
module "ecp_notify_duens_downstream_consentapi_server_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: ConsentAPI Server Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: ConsentAPI causing server errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-preference** encountered server errors above permissible threshold within past 10 minutes, while trying to talk to downstream ConsentAPI service. This could be because of bad requests, unhandled exceptions, etc.\n\nCheck usage-preference service logs [here](${var.usage_preference_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/consentapi/server_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: RMA retry errors
module "ecp_notify_duens_downstream_rma_retry_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: RMA Retry Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: RMA causing retry errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-preference** encountered retry errors above permissible threshold within past 10 minutes, while trying to talk to downstream RMA service. This could be because requests are timing out due to slowness or unavailability.\n\nCheck usage-preference service logs [here](${var.usage_preference_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/rma/retry_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: RMA server errors
module "ecp_notify_duens_downstream_rma_server_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: RMA Server Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: RMA causing server errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-preference** encountered server errors above permissible threshold within past 10 minutes, while trying to talk to downstream RMA service. This could be because of bad requests, unhandled exceptions, etc.\n\nCheck usage-preference service logs [here](${var.usage_preference_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/rma/server_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: CAPI retry errors
module "ecp_notify_duens_downstream_capi_retry_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: CAPI Retry Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: CAPI causing retry errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-customer-info** encountered retry errors above permissible threshold within past 10 minutes, while trying to talk to downstream CAPI service. This could be because requests are timing out due to slowness or unavailability.\n\nCheck usage-customer-info service logs [here](${var.usage_customer_info_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/capi/retry_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: CAPI server errors
module "ecp_notify_duens_downstream_capi_server_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: CAPI Server Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: CAPI causing server errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-customer-info** encountered server errors above permissible threshold within past 10 minutes, while trying to talk to downstream CAPI service. This could be because of bad requests, unhandled exceptions, etc.\n\nCheck usage-customer-info service logs [here](${var.usage_customer_info_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/capi/server_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: CommAPIV2 retry errors
module "ecp_notify_duens_downstream_commapiv2_retry_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: CommAPIV2 Retry Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: CommAPIV2 causing retry errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-policy-subscriber** encountered retry errors above permissible threshold within past 10 minutes, while trying to talk to downstream CommAPIV2 service. This could be because requests are timing out due to slowness or unavailability.\n\nCheck usage-policy-subscriber service logs [here](${var.usage_policy_subscriber_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/commapiv2/retry_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

#GCP DUENS downstream service alert: CommAPIV2 server errors
module "ecp_notify_duens_downstream_commapiv2_server_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[GCP DUENS] [${var.env}] Downstream: CommAPIV2 Server Errors"
  condition_display_name = "[GCP DUENS] [${var.env}] downstream service: CommAPIV2 causing server errors above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "GCP DUENS microservice:**usage-policy-subscriber** encountered server errors above permissible threshold within past 10 minutes, while trying to talk to downstream CommAPIV2 service. This could be because of bad requests, unhandled exceptions, etc.\n\nCheck usage-policy-subscriber service logs [here](${var.usage_policy_subscriber_service_url})."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens/commapiv2/server_error_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "70"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = var.enable_alert
}

resource "google_monitoring_alert_policy" "ecp_redis_cache_health" {
  project               = var.project_id
  display_name          = "[ECP Redis:RED] [${var.env}] Redis primary node is down"
  notification_channels = [data.google_monitoring_notification_channel.ECP.name]
  combiner              = "OR"

  conditions {
    display_name = "Redis is down"
    condition_absent {
      filter   = "metric.type=\"redis.googleapis.com/server/uptime\" resource.type=\"redis_instance\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" metric.label.\"role\"=\"primary\""
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

module "data_usage_onlinemz_request_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "DUENS Low Message volume"
  condition_display_name = "DUENS Low Message volume"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "#notify-data-usage/usage-policy-subscriber received messages lower than threshold.\n\n Please check the message volume on upstrneam topic data.usage."
  filter                 = "metric.type=\"logging.googleapis.com/user/duens_policy_subscriber/onlinemz_message_count\" AND resource.type=\"k8s_container\""
  group_by_fields        = ["resource.label.\"container_name\""]
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "900s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "15"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "600s"
  enabled                = "true"
}

#message transformer pubsub subscription
module "ecp_message_transformer_pubsub_subscription_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Pubsub] [${var.env}] MESSAGE TRANSFORMER Pubsub unacked message"
  condition_display_name = "MESSAGE TRANSFORMER Pubsub subscription unacked message count over threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  content                = "## Pubsub subscription unacked message over the threashold\nThis could caused by pubsub consumer is not processing the message fast enough or not processing the messages at all.\n Please confirm the reported pubsub consumer is up and running and scale up more instances if there is spike in published messages.\nFor consumer running on GKE, run \"kubectl scale deployment deploymentName --replicas=5\" to create more instances"
  filter                 = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=\"${var.ecp_project_id}\" resource.label.\"subscription_id\"=\"message.transformer.subscription\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "20"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = var.enable_alert
}
