# locals {
#   opus_squad3_slack_display_name = format("Google Cloud Alerting-%s Opus Squad3 Slack", upper(var.env))
# }

# variable "opus_squad3_support_slack_channel_name" {
#   type    = string
#   default = ""
# }
# variable "opus_squad3_enable_notification_slack" {
#   type    = string
#   default = ""
# }
# data "google_secret_manager_secret_version" "opus_squad3_secret" {
#   project = var.project_id
#   secret  = "opus_squad3_secret"
# }

# resource "google_monitoring_notification_channel" "opus_squad3_support_slack_channel" {
#   display_name = local.opus_squad3_slack_display_name
#   type         = "slack"
#   project      = var.project_id
#   labels = {
#     "channel_name" = var.opus_squad3_support_slack_channel_name
#   }
#   sensitive_labels {
#     auth_token = data.google_secret_manager_secret_version.opus_squad3_secret.secret_data
#   }
#   enabled = var.opus_squad3_enable_notification_slack
# }