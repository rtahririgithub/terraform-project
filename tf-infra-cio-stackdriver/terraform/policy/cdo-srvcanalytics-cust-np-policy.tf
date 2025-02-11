data "google_monitoring_notification_channel" "customer-service-analytics-support" {
  display_name = "Customer Service Analytics Support"
  project      = var.project_id
}

# resource "google_monitoring_alert_policy" "dataflow_job_failed" {
#   project               = var.project_id
#   display_name          = "cdo-srvcanalytics-cust-np-2597 dataflow job failed policy"
#   notification_channels = [data.google_monitoring_notification_channel.customer-service-analytics-support.name]
#   combiner              = "OR"

#   conditions {
#     display_name = "Workflow failed log"
#     condition_threshold {
#       filter          = "metric.type=\"logging.googleapis.com/user/cdo-srvcanalytics-cust-np-2597-dataflow-job-failed\" AND resource.type=\"dataflow_job\""
#       duration        = "0s"
#       threshold_value = 0.9
#       comparison      = "COMPARISON_GT"
#       aggregations {
#         alignment_period   = "60s"
#         per_series_aligner = "ALIGN_COUNT_TRUE"
#       }
#     }
#   }
# }