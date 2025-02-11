variable "ecp_commapiv2_service_url" {
  description = "ecp_commapiv2_service_url"
  type        = string
  default     = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/communication-api-sender-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
}

module "ecp_bapis_csrs_telus_pickup_email_request_count_high" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CommunicationAPIV2] [${var.env}] BAPIS CSRS Telus pick-up e-mail High Request Count"
  condition_display_name = "[ECP CommunicationAPIV2] [${var.env}] BAPIS CSRS Telus pick-up e-mail request count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/communication-api-sender/bapis_csrs_telus_pickup_email_request_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "80"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "86400s" #24hrs
  enabled                = var.enable_alert
  content                = "ECP has received a high volume of requests for CSRS TELUS pick-up e-mail, exceeding the daily average of **80 requests**. Monitor the incoming requests in logs of [CommunicationAPIV2](${var.ecp_commapiv2_service_url})."
}

module "ecp_bapis_csrs_telus_pickup_email_request_count_low" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CommunicationAPIV2] [${var.env}] BAPIS CSRS Telus pick-up e-mail Low Request Count"
  condition_display_name = "[ECP CommunicationAPIV2] [${var.env}] BAPIS CSRS Telus pick-up e-mail request count below threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/communication-api-sender/bapis_csrs_telus_pickup_email_request_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "86400s" #24hrs
  enabled                = var.enable_alert
  content                = "ECP has received no requests for CSRS TELUS pick-up e-mail in the past 24 hours. Monitor the incoming requests in logs of [CommunicationAPIV2](${var.ecp_commapiv2_service_url})."
}

module "ecp_bapis_csrs_koodo_pickup_email_request_count_high" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CommunicationAPIV2] [${var.env}] BAPIS CSRS Koodo pick-up e-mail High Request Count"
  condition_display_name = "[ECP CommunicationAPIV2] [${var.env}] BAPIS CSRS Koodo pick-up e-mail request count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/communication-api-sender/bapis_csrs_koodo_pickup_email_request_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "12"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "86400s" #24hrs
  enabled                = var.enable_alert
  content                = "ECP has received a high volume of requests for CSRS Koodo pick-up e-mail, exceeding the daily average of **12 requests**. Monitor the incoming requests in logs of [CommunicationAPIV2](${var.ecp_commapiv2_service_url})."
}

module "ecp_bapis_csrs_koodo_pickup_email_request_count_low" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CommunicationAPIV2] [${var.env}] BAPIS CSRS Koodo pick-up e-mail Low Request Count"
  condition_display_name = "[ECP CommunicationAPIV2] [${var.env}] BAPIS CSRS Koodo pick-up e-mail request count below threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/communication-api-sender/bapis_csrs_koodo_pickup_email_request_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "86400s" #24hrs
  enabled                = var.enable_alert
  content                = "ECP has received no requests for CSRS Koodo pick-up e-mail in the past 24 hours. Monitor the incoming requests in logs of [CommunicationAPIV2](${var.ecp_commapiv2_service_url})."
}

module "ecp_bapis_ngc_telus_sales_reservation_email_request_count_high" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CommunicationAPIV2] [${var.env}] BAPIS NGC Telus pick-up e-mail High Request Count"
  condition_display_name = "[ECP CommunicationAPIV2] [${var.env}] BAPIS NGC Telus pick-up e-mail request count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/communication-api-sender/bapis_ngc_telus_sales_reservation_email_request_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "35"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "86400s" #24hrs
  enabled                = var.enable_alert
  content                = "ECP has received a high volume of requests for NGC TELUS reservation e-mail, exceeding the daily average of **35 requests**. Monitor the incoming requests in logs of [CommunicationAPIV2](${var.ecp_commapiv2_service_url})."
}

module "ecp_bapis_ngc_telus_sales_reservation_email_request_count_low" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CommunicationAPIV2] [${var.env}] BAPIS NGC Telus pick-up e-mail Low Request Count"
  condition_display_name = "[ECP CommunicationAPIV2] [${var.env}] BAPIS NGC Telus pick-up e-mail request count below threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/communication-api-sender/bapis_ngc_telus_sales_reservation_email_request_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "86400s" #24hrs
  enabled                = var.enable_alert
  content                = "ECP has received no requests for NGC TELUS reservation e-mail in the past 24 hours. Monitor the incoming requests in logs of [CommunicationAPIV2](${var.ecp_commapiv2_service_url})."
}

module "ecp_bapis_ngc_koodo_sales_reservation_email_request_count_high" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CommunicationAPIV2] [${var.env}] BAPIS NGC Koodo pick-up e-mail High Request Count"
  condition_display_name = "[ECP CommunicationAPIV2] [${var.env}] BAPIS NGC Koodo pick-up e-mail request count above threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/communication-api-sender/bapis_ngc_koodo_sales_reservation_email_request_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "7"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "86400s" #24hrs
  enabled                = var.enable_alert
  content                = "ECP has received a high volume of requests for NGC Koodo reservation e-mail, exceeding the daily average of **7 requests**. Monitor the incoming requests in logs of [CommunicationAPIV2](${var.ecp_commapiv2_service_url})."
}

module "ecp_bapis_ngc_koodo_sales_reservation_email_request_count_low" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP CommunicationAPIV2] [${var.env}] BAPIS NGC Koodo pick-up e-mail Low Request Count"
  condition_display_name = "[ECP CommunicationAPIV2] [${var.env}] BAPIS NGC Koodo pick-up e-mail request count below threshold"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/communication-api-sender/bapis_ngc_koodo_sales_reservation_email_request_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "86400s" #24hrs
  enabled                = var.enable_alert
  content                = "ECP has received no requests for NGC Koodo reservation e-mail in the past 24 hours. Monitor the incoming requests in logs of [CommunicationAPIV2](${var.ecp_commapiv2_service_url})."
}
