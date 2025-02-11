variable "datahub_projects" {
  type = map(any)

}

variable "datahub_enable_notification" {
  type = string
}

variable "bq_sla_metric" {
  type = string
}

variable "sre_sla_check" {
  type = string
}

variable "sre_job_performance_check" {
  type = string
}

variable "sre_latency" {
  type = string
}

variable "user_define_check" {
  type = string
}


data "google_monitoring_notification_channel" "DataHub" {
  display_name = "Datahub Support E-mail"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "DataHub_Infra_Supp" {
  display_name = "Datahub Infrastructure Support E-mail"
  project      = var.project_id
}


### BQ SLA check

resource "google_monitoring_alert_policy" "bq_sla_check_alert" {
  project      = var.project_id
  display_name = "${var.datahub_projects["work"]}_bq_load_monitor"
  combiner     = "OR"
  conditions {
    display_name = "${var.datahub_projects["work"]}_bq_load_monitor"
    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "metric.type=\"${var.bq_sla_metric}\" AND resource.type=\"global\""

      aggregations {

        alignment_period = "90000s" #1 hours
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    # Big query sla mismatch alert
    **  
    **Job Details:**  
    Project: $${resource.project}  
    Alert message: "This table is not loaded from last 24 hours .Please check." 
    **Important Note:** The incident will not be automatically closed on the next successful workflow run. It must be closed manually, or will be automatically closed after 7 days.
    EOT
  }

  enabled               = var.datahub_enable_notification
  notification_channels = [data.google_monitoring_notification_channel.DataHub.name]
}

###BQ SLA check

resource "google_monitoring_alert_policy" "workflow_failure" {
  project      = var.project_id
  display_name = "(cio-datahub) Batch Workflow Failure"
  combiner     = "OR"
  conditions {
    display_name = "Batch Workflow Failure"
    condition_monitoring_query_language {
      query = <<-EOT
        fetch cloud_composer_workflow
        | filter resource.project_id == '${var.datahub_projects["control"]}'
        | metric 'composer.googleapis.com/workflow/run_count'
        | value [succeeded: cast_gauge(if(metric.state == 'success', true(), false()))]
        | unaligned_group_by [resource.workflow_name, resource.project_id],
            [value_failed: count_true(not(succeeded))]
        | align next_older(1d)
        | every 3m
        | condition value_failed > 0 '1'
      EOT

      duration = "0s"
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    # Composer Job Failure Alert
    **A composer workflow run has completed in an successful state.** The Composer environment can be accessed [here](https://console.cloud.google.com/composer/environments?project=$${resource.project}).  
    **Job Details:**  
    Project: $${resource.project}  
    Workflow Name: $${resource.label.workflow_name}  
    This incident will automatically close on the next successful run of this workflow. If there are no runs in the next 7 days, it will close automatically.
    EOT
  }

  enabled               = var.datahub_enable_notification
  notification_channels = [data.google_monitoring_notification_channel.DataHub.name]

}



###sre sla check.
resource "google_monitoring_alert_policy" "sre_sla_check_alert" {
  project      = var.project_id
  display_name = "${var.datahub_projects["work"]}_sre_sla_check"
  combiner     = "OR"
  conditions {
    display_name = "${var.datahub_projects["work"]}_sre_sla_check"
    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "metric.type=\"${var.sre_sla_check}\" AND resource.type=\"global\""

      aggregations {

        alignment_period = "90000s" #1 hours
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    # sre sla check alert policy
    **  
    **Job Details:**  
    Project: $${resource.project}  
    Alert message: "SLA check for table has been failed" 
    **Important Note:** The incident will automatically closed .Please check pipeline for detail information.
    EOT
  }

  enabled               = var.datahub_enable_notification
  notification_channels = [data.google_monitoring_notification_channel.DataHub.name]
}

###sre job performance

resource "google_monitoring_alert_policy" "sre_job_performance_check_alert" {
  count        = var.env == "np" ? 1 : 0
  project      = var.project_id
  display_name = "${var.datahub_projects["work"]}_sre_job_performance_check"
  combiner     = "OR"
  conditions {
    display_name = "${var.datahub_projects["work"]}_sre_job_performance_check"
    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "metric.type=\"${var.sre_job_performance_check}\" AND resource.type=\"global\""

      aggregations {

        alignment_period = "90000s" #1 hours
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    # sre job performance check alert policy
    **  
    **Job Details:**  
    Project: $${resource.project}  
    Alert message: "This composer job was not completed on time." 
    **Important Note:** The incident will automatically closed .Please check pipeline for detail information.
    EOT
  }

  enabled               = var.datahub_enable_notification
  notification_channels = [data.google_monitoring_notification_channel.DataHub.name]
}


###sre_latency

resource "google_monitoring_alert_policy" "sre_latency_alert" {
  project      = var.project_id
  display_name = "${var.datahub_projects["work"]}_sre_latency"
  combiner     = "OR"
  conditions {
    display_name = "${var.datahub_projects["work"]}_sre_latency"
    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "metric.type=\"${var.sre_latency}\" AND resource.type=\"global\""

      aggregations {

        alignment_period = "90000s" #1 hours
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    # sre latency  check alert policy
    **  
    **Job Details:**  
    Project: $${resource.project}  
    Alert message: "SRE latency check has been failed." 
    **Important Note:** The incident will automatically closed .Please check pipeline for detail information.
    EOT
  }

  enabled               = var.datahub_enable_notification
  notification_channels = [data.google_monitoring_notification_channel.DataHub.name]
}


###user define

resource "google_monitoring_alert_policy" "user_define_check_alert" {
  project      = var.project_id
  display_name = "${var.datahub_projects["work"]}_user_define_check"
  combiner     = "OR"
  conditions {
    display_name = "${var.datahub_projects["work"]}_user_define_check"
    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "metric.type=\"${var.user_define_check}\" AND resource.type=\"global\""

      aggregations {

        alignment_period = "90000s" #1 hours
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    # User define  check alert policy
    **  
    **Job Details:**  
    Project: $${resource.project}  
    Pipeline: $${metric.label.table_name}
    Alert message: "User define check has been failed." 
    **Important Note:** The incident will automatically closed .Please check pipeline for detail information.
    EOT
  }

  enabled               = var.datahub_enable_notification
  notification_channels = [data.google_monitoring_notification_channel.DataHub.name]
}


module "datahub_composer_db_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "${var.datahub_projects["control"]}_composer_db_cpu_high_usage"
  condition_display_name = "${var.datahub_projects["control"]}_composer_db_cpu_high_usage"
  notif_id               = [data.google_monitoring_notification_channel.DataHub_Infra_Supp.name]
  content                = "CPU Utilization for Composer $${resource.label.environment_name} database exceeds 90% for 15 mins"
  filter                 = "metric.type=\"composer.googleapis.com/environment/database/cpu/utilization\" AND resource.type=\"cloud_composer_environment\" AND resource.label.\"project_id\"=\"${var.datahub_projects["control"]}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.9"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "900s"
  enabled                = var.datahub_enable_notification
}

module "datahub_composer_db_mem_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "${var.datahub_projects["control"]}_composer_db_mem_high_usage"
  condition_display_name = "${var.datahub_projects["control"]}_composer_db_mem_high_usage"
  notif_id               = [data.google_monitoring_notification_channel.DataHub_Infra_Supp.name]
  content                = "Memory Utilization for Composer $${resource.label.environment_name} database exceeds 90% for 15 mins"
  filter                 = "metric.type=\"composer.googleapis.com/environment/database/memory/utilization\" AND resource.type=\"cloud_composer_environment\" AND resource.label.\"project_id\"=\"${var.datahub_projects["control"]}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.9"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "900s"
  enabled                = var.datahub_enable_notification
}

module "datahub_composer_db_disk_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "${var.datahub_projects["control"]}_composer_db_disk_high_usage"
  condition_display_name = "${var.datahub_projects["control"]}_composer_db_disk_high_usage"
  notif_id               = [data.google_monitoring_notification_channel.DataHub_Infra_Supp.name]
  content                = "Disk Utilization for Composer $${resource.label.environment_name} database exceeds 90% for 6 hour"
  filter                 = "metric.type=\"composer.googleapis.com/environment/database/disk/utilization\" AND resource.type=\"cloud_composer_environment\" AND resource.label.\"project_id\"=\"${var.datahub_projects["control"]}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.9"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "21600s"
  enabled                = var.datahub_enable_notification
}

resource "google_monitoring_alert_policy" "datahub_composer_webserver_cpu_utilization_alert_policy" {
  project      = var.project_id
  display_name = "${var.datahub_projects["control"]}_composer_webserver_cpu_high_usage"
  combiner     = "OR"
  conditions {
    display_name = "${var.datahub_projects["control"]}_composer_webserver_cpu_high_usage"
    condition_monitoring_query_language {
      query = <<-EOT
        fetch cloud_composer_environment
        | filter resource.project_id == '${var.datahub_projects["control"]}'
        | { 
            metric composer.googleapis.com/environment/web_server/cpu/usage_time | rate | group_by 3m, mean(val());
            metric composer.googleapis.com/environment/web_server/cpu/reserved_cores  
          }
        | window 3m
        | ratio
        | condition gt(val(), 0.9)
      EOT

      duration = "900s"
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "CPU Utilization for Composer $${resource.label.environment_name} Web Server exceeds 90% for 15 mins"
  }

  enabled               = var.datahub_enable_notification
  notification_channels = [data.google_monitoring_notification_channel.DataHub_Infra_Supp.name]
}

resource "google_monitoring_alert_policy" "datahub_composer_webserver_mem_utilization_alert_policy" {
  project      = var.project_id
  display_name = "${var.datahub_projects["control"]}_composer_webserver_mem_high_usage"
  combiner     = "OR"
  conditions {
    display_name = "${var.datahub_projects["control"]}_composer_webserver_mem_high_usage"
    condition_monitoring_query_language {
      query = <<-EOT
        fetch cloud_composer_environment
        | filter resource.project_id == '${var.datahub_projects["control"]}'
        | { 
            metric composer.googleapis.com/environment/web_server/memory/bytes_used;
            metric composer.googleapis.com/environment/web_server/memory/quota  
          }
        | window 3m
        | ratio
        | condition gt(val(), 0.9)
      EOT

      duration = "900s"
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "Memory Utilization for Composer $${resource.label.environment_name} Web Server exceeds 90% for 15 mins"
  }

  enabled               = var.datahub_enable_notification
  notification_channels = [data.google_monitoring_notification_channel.DataHub_Infra_Supp.name]
}

module "datahub_composer_node_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "${var.datahub_projects["control"]}_composer_node_cpu_high_usage"
  condition_display_name = "${var.datahub_projects["control"]}_composer_node_cpu_high_usage"
  notif_id               = [data.google_monitoring_notification_channel.DataHub_Infra_Supp.name]
  content                = "CPU Utilization for Composer node $${resource.label.node_name} exceeds 93% for 15 mins"
  filter                 = "metric.type=\"kubernetes.io/node/cpu/allocatable_utilization\" AND resource.type=\"k8s_node\" AND resource.label.\"project_id\"=\"${var.datahub_projects["control"]}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.93"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "900s"
  enabled                = var.datahub_enable_notification
}

module "datahub_composer_node_mem_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "${var.datahub_projects["control"]}_composer_node_mem_high_usage"
  condition_display_name = "${var.datahub_projects["control"]}_composer_node_mem_high_usage"
  notif_id               = [data.google_monitoring_notification_channel.DataHub_Infra_Supp.name]
  content                = "Memory Utilization for Composer node $${resource.label.node_name} exceeds 90% for 15 mins"
  filter                 = "metric.type=\"kubernetes.io/node/memory/allocatable_utilization\" AND resource.type=\"k8s_node\" AND resource.label.\"project_id\"=\"${var.datahub_projects["control"]}\" AND metric.label.\"memory_type\"=\"non-evictable\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.9"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "900s"
  enabled                = var.datahub_enable_notification
}