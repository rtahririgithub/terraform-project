variable "cio_casa_project_name" {
  type    = string
  default = "cio-casa-logging-np-236f51"
}

variable "cio_casa_duration" {
  description = "Duration (in seconds)"
  type        = string
  default     = "0s"
}

variable "cio_casa_comparison" {
  description = "Duration (in seconds)"
  type        = string
  default     = "COMPARISON_GT"
}

variable "cio_casa_alignment_period_day" {
  description = "Time interval for which aggregation takes place (in seconds)"
  type        = string
  default     = "86400s"
}

variable "cio_casa_alignment_period" {
  description = "Time interval for which aggregation takes place (in seconds)"
  type        = string
  default     = "60s"
}

variable "cio_casa_per_series_aligner" {
  type    = string
  default = "ALIGN_SUM"
}

variable "cio_casa_cross_series_reducer" {
  type    = string
  default = "REDUCE_COUNT"
}

variable "cio_casa_trigger_count" {
  type    = string
  default = "1"
}

variable "cio_casa_group_by_fields" {
  type    = list(string)
  default = ["resource.project_id"]
}

locals {
  cio_casa_content = file("${path.module}/cio-casa-policy.md")
}

# Alert for Internal Server Error(500)
module "alert_internal_server_error_500" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Internal Server Error(500)"
  condition_display_name = "CIO CASA - Failed with Internal Server Error(500)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/internal_server_error_500\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "47"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Internal Server Error(500)" })
}

# Alert for Bad Gateway Error(502)
module "alert_bad_gateway_error_502" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Bad Gateway/Invalid response Error(502)"
  condition_display_name = "CIO CASA - Failed with Bad Gateway/Invalid response Error(502)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/bad_gateway_error_502\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "5"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Bad Gateway/Invalid response Error(502)" })
}

# Alert for Service Unavailable(503)
module "alert_service_unavailable_error_503" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Service Unavilable/Connection Reset Error(503)"
  condition_display_name = "CIO CASA - Failed with Service Unavilable/Connection Reset Error(503)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/service_unavailable_error_503\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "13"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Service Unavilable/Connection Reset Error(503)" })
}

# Alert for Gateway Time-out(504)
module "alert_gaetway_timeout_error_504" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Server didn't respond/Gateway Time-out(504)"
  condition_display_name = "CIO CASA - Failed with Server didn't respond/Gateway Time-out(504)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/gateway_timeout_error_504\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "2"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Server didn't respond/Gateway Time-out(504)" })
}

# Alert for Bad Request(400) (casa-genesys-handler alerts removed)
module "alert_bad_request_error_400" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Bad Request(400)"
  condition_display_name = "CIO CASA - API Failed with Bad Request(400)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/bad_request_error_400\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "6002"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Bad Request(400)" })
}

# Alert for Unauthorized(401)
module "alert_unauthorized_error_401" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Unauthorized(401)"
  condition_display_name = "CIO CASA - API Failed with Unauthorized error(401)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/unauthorized_error_401\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "0"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Unauthorized(401)" })
}

# Alert for Unauthorized user(403)
module "alert_forbidden_error_403" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Unauthorized user(403)"
  condition_display_name = "CIO CASA - API Failed with Unauthorized user(403)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/forbidden_error_403\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "0"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Unauthorized user(403)" })
}

# Alert for API not found(404)
module "alert_api_not_found_error_404" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - API Not Found(404)"
  condition_display_name = "CIO CASA - API failed with error(404)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/api_not_found_error_404\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "12"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - API Not Found(404)" })
}

# Alert for property undefined
module "alert_property_undefined" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Cannot read property(undefined)"
  condition_display_name = "CIO CASA - Cannot read property(undefined)"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/property_undefined\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "6167"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Cannot read property(undefined)" })
}

# Alert for address not found
module "alert_address_not_found" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Client cannot connect to address"
  condition_display_name = "CIO CASA - Client cannot connect to address"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/address_not_found\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "77"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Client cannot connect to address" })
}

# Alert for invalid parameter
module "alert_invalid_parameter" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Invalid parameter"
  condition_display_name = "CIO CASA - Failed with Invalid parameter"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/invalid_parameter\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "37"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Failed with Invalid parameter" })
}

# Alert for Sequelize connection error
module "alert_sequelize_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Sequelize Connection Error"
  condition_display_name = "CIO CASA - Failed with Sequelize Connection Error while presisiting/updating feed"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/sequelize_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "1"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Sequelize Connection Error" })
}

# Alert for Packet errors
module "alert_packet_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Packet Processing Error"
  condition_display_name = "CIO CASA - Failed with Packet Processing Error"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/packet_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "8336"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Packet Processing Error" })
}

# Alert for ECP errors
module "alert_ECP_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - ECP communication Error"
  condition_display_name = "CIO CASA - Failed with error while getting ECP communication"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/ECP_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "0"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - ECP communication Error" })
}

# Alert for Task errors
module "alert_task_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Task Cancelled Error"
  condition_display_name = "CIO CASA - Task cancelled due to missing fields"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/task_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "567"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Task Cancelled Error" })
}

# Alert for timezone errors
module "alert_timezone_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Timezone Undefined"
  condition_display_name = "CIO CASA - Failed with timezone undefined"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/timezone_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "14"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Timezone Undefined" })
}

# Alert for API errors
module "alert_api_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - API Error"
  condition_display_name = "CIO CASA - API failed with error"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/api_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "4508"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - API Error" })
}

# Alert for Customer Info errors
module "alert_cid_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Custer Info Error"
  condition_display_name = "CIO CASA - Failed to get Custer Info"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/cid_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "2322"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period_day
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Custer Info Error" })
}

# Alert for JSON errors
module "alert_json_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - JSON format error"
  condition_display_name = "CIO CASA - Failed with Malformed JSON"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/json_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "0"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - JSON format error" })
}

# Alert for Eventlog errors
module "alert_eventlog_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Event log Error"
  condition_display_name = "CIO CASA - Error while processing get event logs from Housekeeper"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/eventlog_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "0"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Event log Error" })
}

# Alert for Redis Connection Reset Error
module "alert_redis_connection_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CIO CASA - Redis Connection Reset Error"
  condition_display_name = "CIO CASA - Failed with Redis Connection Reset Error"
  notif_id               = [data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = var.cio_casa_trigger_count
  per_series_aligner     = var.cio_casa_per_series_aligner
  cross_series_reducer   = var.cio_casa_cross_series_reducer
  filter                 = "metric.type=\"logging.googleapis.com/user/redis_connection_error\" AND resource.type=\"generic_node\""
  enabled                = var.enable_notification
  duration               = var.cio_casa_duration
  threshold_value        = "0"
  comparison             = var.cio_casa_comparison
  alignment_period       = var.cio_casa_alignment_period
  group_by_fields        = var.cio_casa_group_by_fields
  content                = templatefile("${path.module}/cio-casa-policy.md", { alert = "CIO CASA - Redis Connection Reset Error" })
}
