variable "insights_etl_project_name" {
  type    = string
  default = ""
}

variable "insights_etl_project_id" {
  type    = string
  default = ""
}

variable "insights_api_project_name" {
  type    = string
  default = ""
}

variable "insights_api_project_id" {
  type    = string
  default = ""
}

variable "insights_ds_project_name" {
  type    = string
  default = ""
}

variable "insights_datahub_project_name" {
  type    = string
  default = ""
}

variable "insights_covid_ds6_project_name" {
  type    = string
  default = ""
}

variable "insights_covid_ds6_project_id" {
  type    = string
  default = ""
}

variable "insights_enable_notification" {
  type    = string
  default = ""
}

variable "insights_mc_host" {
  type    = string
  default = ""
}

variable "insights_mc_smc_alias" {
  type    = string
  default = ""
}

variable "insights_datahub_landing_project_id" {
  type    = string
  default = ""
}

variable "insights_datahub_work_project_id" {
  type    = string
  default = ""
}

variable "insights_datahub_bq_project_id" {
  type    = string
  default = ""
}

variable "insights_datahub_bq_project_name" {
  type    = string
  default = ""
}

variable "insights_namespace_name" {
  type    = string
  default = ""
}

variable "insights_cluster_name" {
  type    = string
  default = ""
}

variable "insights_gke_project_id" {
  type    = string
  default = ""
}

variable "insights_k8s_pod" {
  type    = string
  default = ""
}

variable "insights_create_alert" {
  type    = bool
  default = true
}


locals {
  insights_content = file("${path.module}/insights-policy.md")
}

data "google_monitoring_notification_channel" "InsightsSupport" {
  display_name = "Insights Support"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "InsightsAppSupport" {
  display_name = "Insights App Support"
  project      = var.project_id
}

resource "google_monitoring_alert_policy" "project_owner_assignments_and_changes_detected" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] project ownership assignment changes 2.4 detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Project Ownership Having highest level of privileges on a project, to avoid misuse of project resources project ownership assignment/change actions mentioned should be monitored and alerted to concerned recipients.
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Project Ownership Having highest level of privileges on a project, to avoid misuse of project resources project ownership assignment/change actions mentioned should be monitored and alerted to concerned recipients.",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}] project ownership assignment changes 2.4 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-project-ownership-assignment-changes-2.4\" AND resource.type=\"global\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields    = ["metric.label.principal_email"]
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-ds-${var.env}] project ownership assignment changes 2.4 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-project-ownership-assignment-changes-2.4\" AND resource.type=\"global\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields    = ["metric.label.principal_email"]
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}] project ownership assignment changes 2.4 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-project-ownership-assignment-changes-2.4\" AND resource.type=\"global\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields    = ["metric.label.principal_email"]
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "audit_configuration_changes_detected" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] audit configuration changes 2.5 detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Admin activity and Data access logs produced by Cloud audit logging enables security analysis, resource change tracking, and compliance auditing. Alert based on any Audit Configuration Changes.
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Admin activity and Data access logs produced by Cloud audit logging enables security analysis, resource change tracking, and compliance auditing. Alert based on any Audit Configuration Changes.",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}]-audit-configuration-changes-2.5 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-audit-configuration-changes-2.5\" "
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }



  conditions {
    display_name = "[cio-insights-ds-${var.env}]-audit-configuration-changes-2.5 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-audit-configuration-changes-2.5\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}]-audit-configuration-changes-2.5 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-audit-configuration-changes-2.5\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "custom_role_changes_detected" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] IAM custom role changes 2.6 detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Alarm for changes IAM Role creation, deletion and updating activities.  Project Owner and administrators with Organization Role Administrator role or the IAM Role Administrator role can create custom roles. Monitoring role creation, deletion and updating activities will help in identifying over-privileged role at early stages.
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Alarm for changes IAM Role creation, deletion and updating activities.  Project Owner and administrators with Organization Role Administrator role or the IAM Role Administrator role can create custom roles. Monitoring role creation, deletion and updating activities will help in identifying over-privileged role at early stages.",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}]-IAM-custom-role-changes-2.6 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-IAM-custom-role-changes-2.6\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-ds-${var.env}]-IAM-custom-role-changes-2.6 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-IAM-custom-role-changes-2.6\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}]-IAM-custom-role-changes-2.6 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-IAM-custom-role-changes-2.6\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "vpc_network_firewall_changes_detected" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] VPC network firewall rule changes 2.7 detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "Alert established for VPC Network Firewall rule changes. Monitoring for Create or Update firewall rule events gives insight network access changes and may reduce the time it takes to detect suspicious activity."
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}]-VPC-network-firewall-rule-changes-2.7 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-VPC-network-firewall-rule-changes-2.7\" AND resource.type=\"global\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-ds-${var.env}]-VPC-network-firewall-rule-changes-2.7 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-VPC-network-firewall-rule-changes-2.7\" AND resource.type=\"global\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}]-VPC-network-firewall-rule-changes-2.7 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-VPC-network-firewall-rule-changes-2.7\" AND resource.type=\"global\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "vpc_network_route_changes_detected" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] VPC network route changes 2.8 detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    "Alert for VPC network route changes. Google Cloud Platform (GCP) routes define the paths network traffic takes from a VM instance to another destinations. The other destination can be inside your VPC network (such as another VM) or outside of it. Every route consists of a destination and a next hop. Traffic whose destination IP is within the destination range is sent to the next hop for delivery.  Monitoring changes to route tables will help ensure that all VPC traffic flows through an expected path."
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Alert for VPC network route changes. Google Cloud Platform (GCP) routes define the paths network traffic takes from a VM instance to another destinations. The other destination can be inside your VPC network (such as another VM) or outside of it. Every route consists of a destination and a next hop. Traffic whose destination IP is within the destination range is sent to the next hop for delivery.  Monitoring changes to route tables will help ensure that all VPC traffic flows through an expected path.",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}]-VPC-network-route-changes-2.8 detetected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-VPC-network-route-changes-2.8\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-ds-${var.env}]-VPC-network-route-changes-2.8 detetected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-VPC-network-route-changes-2.8\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}]-VPC-network-route-changes-2.8 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-VPC-network-route-changes-2.8\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "vpc_network_changes_detected" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] VPC network changes 2.9 detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Alert for VPC network changes. It is possible to have more than 1 VPC within an project, in addition it is also possible to create a peer connection between 2 VPCs enabling network traffic to route between VPCs. Monitoring changes to VPC will help ensure VPC traffic flow is not getting impacted.
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Alert for VPC network changes. It is possible to have more than 1 VPC within an project, in addition it is also possible to create a peer connection between 2 VPCs enabling network traffic to route between VPCs. Monitoring changes to VPC will help ensure VPC traffic flow is not getting impacted.",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}]-VPC-network-changes-2.9 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-VPC-network-changes-2.9\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-ds-${var.env}]-VPC-network-changes-2.9 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-VPC-network-changes-2.9\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}]-VPC-network-changes-2.9 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-VPC-network-changes-2.9\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "iam_changes_detected" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] Cloud Storage IAM permission changes 2.10 detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Alert for Cloud Storage Bucket IAM changes. Monitoring changes to Cloud Storage bucket permissions may reduce time to detect and correct permissions on sensitive Cloud Storage bucket and objects inside the bucket
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Alert for Cloud Storage Bucket IAM changes. Monitoring changes to Cloud Storage bucket permissions may reduce time to detect and correct permissions on sensitive Cloud Storage bucket and objects inside the bucket.",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}]-Cloud-Storage-IAM-permission-changes-2.10 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-Cloud-Storage-IAM-permission-changes-2.10\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-ds-${var.env}]-Cloud-Storage-IAM-permission-changes-2.10 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-Cloud-Storage-IAM-permission-changes-2.10\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}]-Cloud-Storage-IAM-permission-changes-2.10 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-Cloud-Storage-IAM-permission-changes-2.10\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "sql_instance_configuration_changes" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] SQL instance configuration changes 2.11 detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "Fires when there are changes in configuration for SQL instances"
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}]-SQL-instance-configuration-changes-2.11 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-SQL-instance-configuration-changes-2.11\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-ds-${var.env}]-SQL-instance-configuration-changes-2.11 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-SQL-instance-configuration-changes-2.11\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}]-SQL-instance-configuration-changes-2.11 detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-SQL-instance-configuration-changes-2.11\" AND resource.type=\"global\""
      threshold_value = 1
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "gcs_bucket_non_whitelist_ip_detected" {
  count                 = 0
  project               = var.project_id
  display_name          = "[cio-insights] GCS Bucket Non-White List IP access detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Need to remove permissions for any accounts connecting from non-White List IPs\n\nTo troubleshoot:\n1. In GCP console navigate to Logging > Logs-based metrics > User-defined Metrics\n2.  To the right of the user/GCS-Bucket-Non-White-List-IP-detected, click the 3 dots, choose Edit metric\n3.  In the Metric Editor submit the query filter for last 1hr (or within timing of alert event) to capture the log data\n4. Click Download Logs, chose CSV as the Log entry format, click Download\n5.  Save the log CSV file to your local computer\n6.  Open the log CSV file in Excel\n7.  Identify the protoPayload.authenticationInfo.principalEmail and protoPayload.requestMetadata.callerIp records that triggered the alert.\n\nResolution Steps:\n1.  In GCP console navigate to IAM & Admin > IAM\n2.  Based on protoPayload.authenticationInfo.principalEmail from above CSV log file, click edit remove all permissions from the account. \n3. Further steps coming soon: Terraform scripts and steps to remove acct and bound services, then spin up a new account and services in a later release
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Need to remove permissions for any accounts connecting from non-White List IPs\n\nTo troubleshoot:\n1. In GCP console navigate to Logging > Logs-based metrics > User-defined Metrics\n2.  To the right of the user/GCS-Bucket-Non-White-List-IP-detected, click the 3 dots, choose Edit metric\n3.  In the Metric Editor submit the query filter for last 1hr (or within timing of alert event) to capture the log data\n4. Click Download Logs, chose CSV as the Log entry format, click Download\n5.  Save the log CSV file to your local computer\n6.  Open the log CSV file in Excel\n7.  Identify the protoPayload.authenticationInfo.principalEmail and protoPayload.requestMetadata.callerIp records that triggered the alert.\n\nResolution Steps:\n1.  In GCP console navigate to IAM & Admin > IAM\n2.  Based on protoPayload.authenticationInfo.principalEmail from above CSV log file, click edit remove all permissions from the account. \n3. Further steps coming soon: Terraform scripts and steps to remove acct and bound services, then spin up a new account and services in a later release",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[cio-insights-etl-${var.env}]-GCS-Bucket-Non-White-List-IP-access detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-GCS-Bucket-Non-White-List-IP-detected\" AND resource.type=\"gcs_bucket\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-ds-${var.env}]-GCS-Bucket-Non-White-List-IP-access detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_ds_project_name})-GCS-Bucket-Non-White-List-IP-detected\" AND resource.type=\"gcs_bucket\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "[cio-insights-api-${var.env}]-GCS-Bucket-Non-White-List-IP-access detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/(${var.insights_api_project_name})-GCS-Bucket-Non-White-List-IP-detected\" AND resource.type=\"gcs_bucket\""
      threshold_value = 0.001
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "dataflow_pdc_untar_pipeline_lags" {
  count        = var.env == "np" ? 1 : 0
  project      = var.project_id
  display_name = "[${var.insights_etl_project_name}] PDC untar pipeline lag above 500s for a period of 5 mins"

  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    ${var.insights_etl_project_name}] PDC untar pipeline lag above 500s for a period of 5 mins
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"[${var.insights_etl_project_name}] PDC untar pipeline lag above 500s for a period of 5 mins",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] PDC untar pipeline lag above 500s for a period of 5 mins"

    condition_threshold {
      filter          = "metric.type=\"dataflow.googleapis.com/job/system_lag\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=${var.insights_etl_project_id} resource.label.\"job_name\"=starts_with(\"streaming-pdc-untar-ingestion\")"
      threshold_value = 500
      duration        = "300s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "dataflow_pdc_pipeline_lags" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] PDC pipeline lag above 500s for a period of 5 mins"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    ${var.insights_etl_project_name} PDC hash pipeline lag above 500s for a period of 5 mins
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"${var.insights_etl_project_name} PDC hash pipeline lag above 500s for a period of 5 mins",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] PDC pipeline lag above 500s for a period of 5 mins"

    condition_threshold {
      filter          = "metric.type=\"dataflow.googleapis.com/job/system_lag\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=${var.insights_etl_project_id} resource.label.\"job_name\"=starts_with(\"streaming-pdc-ingestion\")"
      threshold_value = 500
      duration        = "300s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "dataflow_pdc_pipeline_cpu_utilization" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[cio-insights] Dataflow PDC-Pipeline CPU utilization is above 90% for 10 minutes"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "Dataflow PDC-Pipeline CPU utilization is above 90% for 10 minutes"
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] Dataflow PDC-Pipeline CPU utilization is above 90% for 10 minutes"

    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"project_id\"=${var.insights_etl_project_id} metadata.user_labels.\"dataflow_job_name\"=starts_with(\"streaming-pdc-ingestion\")"
      threshold_value = 0.90
      duration        = "600s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MAX"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "dataflow_pdc_untar_cpu_utilization" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[cio-insights] Dataflow PDC-Untar CPU utilization is above 90% for 10 minutes"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "Dataflow PDC-Untar CPU utilization is above 90% for 10 minutes"
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] Dataflow PDC-Untar CPU utilization is above 90% for 10 minutes"

    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"project_id\"=${var.insights_etl_project_id} metadata.user_labels.\"dataflow_job_name\"=starts_with(\"streaming-pdc-untar-ingestion\")"
      threshold_value = 0.90
      duration        = "600s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MAX"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "pubsub_pdc_landing_pull_unack" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[cio-insights] Unack message count on pdc-landing-pull subscription is above 10 for 5 minutes"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Unack message count on pdc-landing-pull subscription is above 10 for 5 minutes
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Unack message count on pdc-landing-pull subscription is above 10 for 5 minutes.",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] Unack message count on pdc-landing-pull subscription is above 10 for 5 minutes"

    condition_threshold {
      filter          = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"project_id\"=${var.insights_etl_project_id} resource.label.\"subscription_id\"=\"pdc-landing-pull\""
      threshold_value = 10
      duration        = "300s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "pdc_live_opt_in_last_modified" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[cio-insights] PDC_live_opt_in BQ table last modified is greater than 25 minutes"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "PDC_live_opt_in BQ table last modified is greater than 25 minutes"
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] PDC_live_opt_in BQ table last modified is greater than 25 minutes"

    condition_threshold {
      filter          = "resource.type=\"bigquery_dataset\" AND metric.type=\"logging.googleapis.com/user/PDC_live_opt_in_last_modified\""
      threshold_value = 1
      duration        = "1500s"
      comparison      = "COMPARISON_LT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "1500s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }
    }

  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "file_last_dropped_drop_pdc_tar_folder" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[cio-insights] File was last dropped in drop-pdc-tars folder more than 25 minutes ago"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    File was last dropped in drop-pdc-tars folder more than 25 minutes ago
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"File was last dropped in drop-pdc-tars folder more than 25 minutes ago.",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] File was last dropped in drop-pdc-tars folder more than 25 minutes ago"

    condition_threshold {
      filter          = "resource.type=\"gcs_bucket\" AND metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-drop-PDC-tars-bucket-file-detector\""
      threshold_value = 1
      duration        = "1500s"
      comparison      = "COMPARISON_LT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "1500s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "file_last_dropped_drop_pdc_folder" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[cio-insights] File was last dropped in drop-pdc folder more than 25 minutes ago"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "File was last dropped in drop-pdc folder more than 25 minutes ago"
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] File was last dropped in drop-pdc folder more than 25 minutes ago"

    condition_threshold {
      filter          = "resource.type=\"gcs_bucket\" AND metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-drop-PDC-bucket-file-detector\""
      threshold_value = 1
      duration        = "1500s"
      comparison      = "COMPARISON_LT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "1500s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }
    }

  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "insights_dag_failure" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  display_name          = "[cio-etl-insights] Dag Failure"
  combiner              = "OR"
  conditions {
    display_name = "Dag Failure"
    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = <<-EOT
      project = "${var.insights_etl_project_id}" AND
      resource.type = "cloud_composer_workflow" AND
      metric.type = "composer.googleapis.com/workflow/run_count" AND
      metric.labels.state = "failed"
      EOT
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    # Composer Job Failure Alert
    **A composer workflow run has entered a failed state.**.  
    **Job Details:**  
    Project: $${resource.project}  
    Workflow Name: $${resource.label.workflow_name}
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Dag failure detected. $${resource.label.workflow_name}",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "BQ_swanetl_landing_pdc_errors_uploaded_row_detected" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] BQ_swanetl_landing_pdc_errors uploaded row detected"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "swanetl_landing.pdc_errors_uploaded_row_detected, alert is to avoid data issues"
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] BQ_swanetl_landing_pdc_errors uploaded row detected"

    condition_threshold {
      filter          = "resource.type=\"bigquery_dataset\" AND metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-pdc_errors-table-row-upload\""
      threshold_value = 0
      duration        = "0s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "BQ_swanetl_landing_pdc_daily_duplicate_file_count_issue" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] BQ_swanetl_landing_pdc_daily_duplicate_file_count_issue"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    A file has count of records > 200000
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"A file has count of records > 200000",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] BQ_swanetl_landing_pdc_daily_duplicate_file_count_issue"

    condition_threshold {
      filter          = "resource.type=\"bigquery_dataset\" AND metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-pdc_daily_duplicate_file_count_issue\""
      threshold_value = 0
      duration        = "0s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "BQ_swanetl_landing_pdc_daily_file_count_issue" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] BQ_swanetl_landing_pdc_daily_file_count_issue"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Daily distinct file count deviated by more than 20%
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Daily distinct file count deviated by more than 20%",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] BQ_swanetl_landing__pdc_daily_file_count_issue"

    condition_threshold {
      filter          = "resource.type=\"bigquery_dataset\" AND metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-pdc_daily_file_count_issue\""
      threshold_value = 0
      duration        = "0s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "BQ_swanetl_landing_pdc_daily_total_row_count_issue" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] BQ_swanetl_landing_pdc_daily_total_row_count_issue"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Daily total row count deviated by more than 20%
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Daily total row count deviated by more than 20%",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] BQ_swanetl_landing_pdc_daily_total_row_count_issue"

    condition_threshold {
      filter          = "resource.type=\"bigquery_dataset\" AND metric.type=\"logging.googleapis.com/user/(${var.insights_etl_project_name})-pdc_daily_total_row_count_issue\""
      threshold_value = 0
      duration        = "0s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "drop_pdc_tar_folder_bytes_recieved_below_threshold" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}]-drop-pdc-tars storage bucket bytes received below threshold"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "[${var.insights_etl_project_name}]-drop-pdc-tars received_bytes_count stream is below a threshold of 10000000000 - 9.3G in 6 hours"
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}]-drop-pdc-tars bytes received below Threshold"

    condition_threshold {
      filter          = "metric.type=\"storage.googleapis.com/network/received_bytes_count\" resource.type=\"gcs_bucket\" resource.label.\"project_id\"=${var.insights_etl_project_id} resource.label.\"bucket_name\"=\"${var.insights_etl_project_id}-drop-pdc-tar-folders\" metric.label.\"response_code\"=\"OK\" metric.label.\"method\"=\"WriteObject\""
      threshold_value = 16000000000
      duration        = "21600s"
      comparison      = "COMPARISON_LT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "21600s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "GAE_Instance_CPU_Utilization" {
  count                 = 0
  project               = var.project_id
  display_name          = "[${var.insights_api_project_name}] GAE Instance CPU Utilization is above a threshold of 95% for greater than 1 minute"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "${var.insights_api_project_name} GCE Instance CPU Utilization is above a threshold of 95% for greater than 1 minute"
  }

  conditions {
    display_name = "[${var.insights_api_project_name}] GAE Instance CPU Utilization is above a threshold of 95% for greater than 1 minute"

    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"project_id\"=${var.insights_api_project_id}"
      threshold_value = 0.95
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "bigquery_slot_usage_insights" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] BigQuery slot usage is above 500 for 10 mins"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "${var.insights_etl_project_id} BigQuery slot usage is above 500 for 10 mins"
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] BigQuery slot usage is above 500 for 10 mins"

    condition_threshold {
      filter          = "metric.type=\"bigquery.googleapis.com/slots/allocated_for_project\" resource.type=\"global\" resource.label.\"project_id\"=${var.insights_etl_project_id}"
      threshold_value = 500
      duration        = "600s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "600s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "bigquery_slot_usage_covid_ds6" {
  count                 = 0
  project               = var.project_id
  display_name          = "[${var.insights_covid_ds6_project_name}] BigQuery slot usage is above 1500 for 10 mins"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "${var.insights_covid_ds6_project_name} BigQuery slot usage is above 1500 for 10 mins"
  }

  conditions {
    display_name = "[${var.insights_covid_ds6_project_name}] BigQuery slot usage is above 1500 for 10 mins"

    condition_threshold {
      filter = "metric.type=\"bigquery.googleapis.com/slots/allocated_for_project\" resource.type=\"global\" resource.label.\"project_id\"=${var.insights_covid_ds6_project_id}"

      threshold_value = 1500
      duration        = "600s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "600s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "Insights_datahub_api_cloudfunction_failure" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_datahub_project_name}] Insights datahub api cloudfunction failure json"
  notification_channels = [data.google_monitoring_notification_channel.InsightsAppSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Insights datahub api cloudfunction failure
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Insights datahub api cloudfunction failure",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_datahub_project_name}] Insights_datahub_api_cloudfunction_failure_json"

    condition_threshold {
      filter          = "resource.type=\"cloud_function\" AND metric.type=\"logging.googleapis.com/user/${var.insights_datahub_project_name}-cloud-function-failure\""
      threshold_value = 0
      duration        = "60s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "600s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}


resource "google_monitoring_alert_policy" "Utilization_pdc_filter_dataflow_above_18_workers" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] Worker Utilization for pdc-filter dataflow above 18 workers"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    ${var.insights_etl_project_name}] Worker Utilization for pdc-filter dataflow above 18 workers
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"[${var.insights_etl_project_name}] Worker Utilization for pdc-filter dataflow above 18 workers",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] Worker Utilization for pdc-filter dataflow above 18 workers"

    condition_threshold {
      filter          = "metric.type=\"dataflow.googleapis.com/job/current_num_vcpus\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=${var.insights_datahub_work_project_id} resource.label.\"job_name\"=starts_with(\"insights-pdc-filter\")"
      threshold_value = 36
      duration        = "600s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "Utilization_pdc_untar_dataflow_above_18_workers" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] Worker Utilization pdc-untar above 18 workers"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    ${var.insights_etl_project_name}] Worker Utilization pdc-untar above 18 workers
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"[${var.insights_etl_project_name}] Worker Utilization pdc-untar above 18 workers",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] Worker Utilization pdc-untar above 18 workers"

    condition_threshold {
      filter          = "metric.type=\"dataflow.googleapis.com/job/current_num_vcpus\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=${var.insights_datahub_work_project_id} resource.label.\"job_name\"=starts_with(\"insights-pdc-untar\")"
      threshold_value = 36
      duration        = "600s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "Utlization_pdc_mask_dataflow_above_18_workers" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_etl_project_name}] Worker utlization on pdc-mask above 18 workers"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    ${var.insights_etl_project_name}] Worker utlization on pdc-mask above 18 workers
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"[${var.insights_etl_project_name}] Worker utlization on pdc-mask above 18 workers",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_etl_project_name}] Worker utlization on pdc-mask above 18 workers"

    condition_threshold {
      filter          = "metric.type=\"dataflow.googleapis.com/job/current_num_vcpus\" resource.type=\"dataflow_job\" resource.label.\"project_id\"=${var.insights_datahub_work_project_id} resource.label.\"job_name\"=starts_with(\"insights-pdc-mask\")"
      threshold_value = 36
      duration        = "600s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "BQ_pdc_optout_daily_total_row_count_issue" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_datahub_work_project_id}] BQ_pdc_optout_daily_total_row_count_issue"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Daily total row count deviated by more than 20%
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Daily optout total row count deviated by more than 10%",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_datahub_work_project_id}] BQ_pdc_optout_daily_total_row_count_issue"

    condition_threshold {
      filter          = "metric.type=\"bigquery.googleapis.com/storage/uploaded_row_count\" AND resource.type=\"bigquery_dataset\" AND resource.label.\"project_id\"=\"${var.insights_datahub_work_project_id}\" AND resource.label.\"dataset_id\"=\"datahub_operations\" AND metric.label.\"table\"=\"insights_daily_optout_total_row_count_issue\""
      threshold_value = 0
      duration        = "0s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "360s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "Insights_datahub_bq_pending_running_job_over_20" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[${var.insights_datahub_bq_project_name}] Insights_datahub_bq_pending_running_job_over_20"
  notification_channels = [data.google_monitoring_notification_channel.InsightsAppSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Insights_datahub_bq_pending_running_job_over_20
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Insights_datahub_bq_pending_running_job_over_20",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_datahub_bq_project_name}] Insights_datahub_bq_pending_running_job_over_20"

    condition_threshold {
      filter          = "metric.type=\"bigquery.googleapis.com/job/num_in_flight\" resource.type=\"bigquery_project\" resource.label.\"project_id\"=\"${var.insights_datahub_bq_project_id}\" AND metric.label.\"job_type\"=\"query\" metric.label.\"state\"!=\"done\""
      threshold_value = 20
      duration        = "600s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["metric.label.principal_email"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "Insights_datahub_k8s_container_error" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "${var.insights_gke_project_id}] GKE container error was found for Insights pod/app"
  notification_channels = [data.google_monitoring_notification_channel.InsightsSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    GKE container error was found for Insights  pod/app
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"GKE container error was found for Insights pod/app",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_gke_project_id}] GKE container error was found for Insights pod/app"

    condition_matched_log {
      filter = "resource.type=\"k8s_container\" AND resource.labels.\"project_id\"=\"${var.insights_gke_project_id}\" resource.labels.\"cluster_name\"=\"${var.insights_cluster_name}\" AND resource.labels.\"namespace_name\"=\"${var.insights_namespace_name}\" AND severity=ERROR"
    }

  }
  alert_strategy {
    auto_close = "604800s"
    notification_rate_limit {
      period = "3600s"
    }
  }
  enabled = var.insights_enable_notification
}

resource "google_monitoring_alert_policy" "Insights_datahub_container_restart" {
  count                 = 0
  project               = var.project_id
  display_name          = "[${var.insights_gke_project_id}] Insights_datahub_container_restart"
  notification_channels = [data.google_monitoring_notification_channel.InsightsAppSupport.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    Insights_datahub_container_restart
    ```json
    {
      "mc_host":"${var.insights_mc_host}",
      "severity":"CRITICAL",
      "msg":"Insights_datahub_container_restart",
      "mc_smc_alias":"${var.insights_mc_smc_alias}"
    }
    ```
    EOT
  }

  conditions {
    display_name = "[${var.insights_gke_project_id}] Insights_datahub_container_restart"

    condition_threshold {
      filter          = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"cluster_name=\"=\"${var.insights_cluster_name}\" resource.label.\"namespace_name\"=\"${var.insights_namespace_name}\""
      threshold_value = 0
      duration        = "0s"
      comparison      = "COMPARISON_GT"

      trigger {
        count = 1
      }

      aggregations {
        group_by_fields      = ["resource.label.\"container_name\""]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  enabled = var.insights_enable_notification
}

