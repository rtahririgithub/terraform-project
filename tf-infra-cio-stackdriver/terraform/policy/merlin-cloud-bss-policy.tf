variable "qry_memorywarning_metric" {
  type    = string
  default = ""
}
variable "qry_memoryCritical_metric" {
  type    = string
  default = ""
}
variable "qry_CPUwarning_metric" {
  type    = string
  default = ""
}
variable "qry_CPUCritic_metric" {
  type    = string
  default = ""
}
variable "duration_policy" {
  type    = string
  default = ""
}
variable "qry_merlin_Cloud_BSS_dplycntrl" {
  type    = string
  default = ""
}

#TrueSight

#declaring locals
locals {
  merlin_cloud_bss_email_display_name = format("Google Cloud Alerting-%s MERLIN Cloud-BSS Email", upper(var.env))
}

data "google_monitoring_notification_channel" "merlin_cloud_bss_support_email_channel" {
  display_name = local.merlin_cloud_bss_email_display_name
  project      = var.project_id
}

# Merlin Deploy Metrics control alert
resource "google_monitoring_alert_policy" "MERLIN-BSS-CLOUD-WORKLOADCHANGE" {
  project               = var.project_id
  display_name          = format("[Merlin][%s] - Deploy Control", upper(var.env))
  notification_channels = [data.google_monitoring_notification_channel.merlin_cloud_bss_support_email_channel.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-DMC.md")
  }

  conditions {
    display_name = format("Detected Manual Workload Change [%s]", upper(var.env))
    condition_monitoring_query_language {
      query    = var.qry_merlin_Cloud_BSS_dplycntrl
      duration = "0s"
    }
  }
}

resource "google_monitoring_alert_policy" "MERLIN-BSS-CLOUD-MEMORYWARNING" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[Memory rise: YELLOW] [${var.env}] Resource Constrained"
  notification_channels = [data.google_monitoring_notification_channel.merlin_cloud_bss_support_email_channel.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "# [Merlin Cloud BSS] 70% Memory Limit per Node **Reached** **This is an example**"
  }

  conditions {
    display_name = "MERLIN-BSS-CLOUD memory utilization at 70%"
    condition_monitoring_query_language {
      query    = var.qry_memorywarning_metric
      duration = var.duration_policy
    }
  }
}

resource "google_monitoring_alert_policy" "MERLIN-BSS-CLOUD-MEMORYCRITICAL" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[Memory rise: red] [${var.env}] Resource Critical"
  notification_channels = [data.google_monitoring_notification_channel.merlin_cloud_bss_support_email_channel.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "# [Merlin Cloud BSS] 85% Memory Limit per Node **Reached** **This is an example** "
  }

  conditions {
    display_name = "MERLIN-BSS-CLOUD memory utilization at 85%"
    condition_monitoring_query_language {
      query    = var.qry_memoryCritical_metric
      duration = var.duration_policy
    }
  }
}
resource "google_monitoring_alert_policy" "MERLIN-BSS-CLOUD-CPUWARNING" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[CPU rise: YELLOW] [${var.env}] Resource Constrained"
  notification_channels = [data.google_monitoring_notification_channel.merlin_cloud_bss_support_email_channel.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "# [Merlin Cloud BSS] 80% CPU Limit per Node **Reached** **This is an example** "
  }

  conditions {
    display_name = "MERLIN-BSS-CLOUD memory utilization at 80%"
    condition_monitoring_query_language {
      query    = var.qry_CPUwarning_metric
      duration = var.duration_policy
    }
  }
}
resource "google_monitoring_alert_policy" "MERLIN-BSS-CLOUD-CPUCRITICAL" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "[Memory rise: RED] [${var.env}] Resource Critical"
  notification_channels = [data.google_monitoring_notification_channel.merlin_cloud_bss_support_email_channel.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "# [Merlin Cloud BSS] 75% CPU Limit per Node **Reached** **This is an example** "
  }

  conditions {
    display_name = "MERLIN-BSS-CLOUD CPU utilization at 75%"
    condition_monitoring_query_language {
      query    = var.qry_CPUCritic_metric
      duration = var.duration_policy
    }
  }
}

## TrueSight integration 

## To check mc_smc_alias you need to go to: https://watchtower.tsl.telus.com/cgi-bin/dosql/bppm/ci_impacts and search for your CI name
variable "merlin_core_project_id" {
  type    = string
  default = ""
}

variable "merlin_gke_project_id" {
  type    = string
  default = ""
}

variable "merlin_core_project_name" {
  type    = string
  default = ""
}

variable "merlin_gke_project_name" {
  type    = string
  default = ""
}

variable "qry_merlin_CPQ_Alert" {
  type    = string
  default = "fetch k8s_container | metric 'kubernetes.io/container/uptime' | filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}' ) | filter(resource.container_name == 'quotation-engine-service-gateway'|| resource.container_name == 'quotation-engine-service-v1'|| resource.container_name == 'quote-ibi-tracking-service-gateway'|| resource.container_name == 'quote-ibi-tracking-service-v1'|| resource.container_name == 'quote-storage-service-gateway'|| resource.container_name == 'quote-storage-service-v1'|| resource.container_name == 'quote-tmf-service-gateway'|| resource.container_name == 'quote-tmf-service-v1'|| resource.container_name == 'quote-tracking-service-gateway'|| resource.container_name == 'quote-tracking-service-v1'|| resource.container_name == 'shopping-cart-tmf-service-gateway'|| resource.container_name == 'shopping-cart-tmf-service-v1'|| resource.container_name == 'quote-mutation-service-gateway'|| resource.container_name == 'quote-mutation-service-v1'|| resource.container_name == 'quote-notification-service-gateway'|| resource.container_name == 'quote-notification-service-v1'|| resource.container_name == 'pim-core-srv'|| resource.container_name == 'private-frontend-gateway'|| resource.container_name == 'public-frontend-gateway'|| resource.container_name == 'samples-repository'|| resource.container_name == 'scheduling-service-gateway'|| resource.container_name == 'scheduling-service-v1'|| resource.container_name == 'site-management'|| resource.container_name == 'smartplug'|| resource.container_name == 'submission-handler-service-gateway'|| resource.container_name == 'submission-handler-service-v1') | align rate(5m) | every 5m | condition (value.uptime < 1)"
}
variable "qry_merlin_Design_Time_Catalog" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}')| filter (resource.container_name=='catalog-service-v1'||resource.container_name=='catalog-validation-service-gateway'||resource.container_name=='catalog-validation-service-v1'||resource.container_name=='pim-frontend-srv') | align rate(5m)| every 5m|condition (value.uptime <  1 )"
}
variable "qry_merlin_Install_Base" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}')| filter (resource.container_name=='install-base-service-gateway'||resource.container_name=='install-base-service-v1'||resource.container_name=='ibs-sync-service')| align rate(5m)| every 5m|condition (value.uptime <  1 )"
}
variable "qry_merlin_Run_Time_Catalog" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}')| filter (resource.container_name=='catalog-integration-tmf-v1'||resource.container_name=='catalog-service-gateway'||resource.container_name=='offering-qualification-service-gateway'||resource.container_name=='offering-qualification-service-v1'||resource.container_name=='marketing-catalog-service-gateway'||resource.container_name=='marketing-catalog-service-v1'||resource.container_name=='pim-brci-srv'||resource.container_name=='pim-content-hub-srv'||resource.container_name=='promotion-service-gateway'||resource.container_name=='promotion-service-v1')| align rate(5m)| every 5m|condition (value.uptime <  1 )"
}
variable "qry_merlin_Core_App_Alert" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}')| filter (resource.container_name=='cim-integration-service-gateway'||resource.container_name=='cim-integration-service-v1'||resource.container_name=='cloud-administrator-frontend'||resource.container_name=='config-server'||resource.container_name=='content-delivery'||resource.container_name=='content-delivery-aggregator'||resource.container_name=='content-delivery-manager'||resource.container_name=='control-panel-backend'||resource.container_name=='control-plane'||resource.container_name=='customization-manager'||resource.container_name=='dbaas-agent' ||resource.container_name=='dictionaries-provider-backend'||resource.container_name=='domain-resolver-frontend'||resource.container_name=='facade-operator'||resource.container_name=='frontend-delivery-manager'||resource.container_name=='gateway-auth-extension'||resource.container_name=='graphql-server'||resource.container_name=='identity-provider'||resource.container_name=='internal-gateway'||resource.container_name=='maas-agent'||resource.container_name=='metamodel-editor'||resource.container_name=='metamodel-provider-backend'||resource.container_name=='monitoring-agent'||resource.container_name=='mui-platform'||resource.container_name=='notification-engine'||resource.container_name=='paas-mediation')| align rate(5m)| every 5m|condition (value.uptime <  1 )"
}
variable "qry_merlin_Catalog_Sync_Service" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}')| filter (resource.container_name=='dt-catalog-sync-service')| align rate(5m)| every 5m|condition (value.uptime <  1 )"
}
variable "qry_merlin_Cloud_BSS_Core2" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}')| filter (resource.container_name=='tenant-manager'||resource.container_name=='tenant-manager'||resource.container_name=='tenant-self-service-frontend'||resource.container_name=='user-management-frontend'||resource.container_name=='worklog-service-gateway'||resource.container_name=='worklog-service-v1'||resource.container_name=='categorizer-service'||resource.container_name=='cleaning-service'||resource.container_name=='data-transformation-service'||resource.container_name=='key-manager'||resource.container_name=='monitor-service'||resource.container_name=='org-chart-backend-app'||resource.container_name=='org-chart-frontend-app-ui'||resource.container_name=='smartplug-frontend')| align rate(5m)| every 5m|condition (value.uptime <  1 )"
}
variable "qry_merlin_maintenance_ns" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}')| filter (resource.container_name=='tenant-manager'||resource.container_name=='tenant-manager'||resource.container_name=='tenant-self-service-frontend'||resource.container_name=='user-management-frontend'||resource.container_name=='worklog-service-gateway'||resource.container_name=='worklog-service-v1'||resource.container_name=='categorizer-service'||resource.container_name=='cleaning-service'||resource.container_name=='data-transformation-service'||resource.container_name=='key-manager'||resource.container_name=='monitor-service'||resource.container_name=='org-chart-backend-app'||resource.container_name=='org-chart-frontend-app-ui'||resource.container_name=='smartplug-frontend')| align rate(5m)| every 5m|condition (value.uptime <  1 )"
}
variable "qry_merlin_Cloud_BSS_Core_SQL" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ 'nc-private-yul-.*')| filter (resource.container_name=='dbaas-postgres-adapter'||resource.container_name=='postgres-operator'||resource.container_name=='nc-dbaas-postgres-adapter'||resource.container_name=='postgres-backup-daemon'||resource.container_name=='cloudsql-proxy-cloud-om-ops-dv'||resource.container_name=='cloudsql-proxy-default-ops-dv'||resource.container_name=='cloudsql-proxy-dv'||resource.container_name=='cloudsql-proxy-install-base-ops-dv'||resource.container_name=='cloudsql-proxy-kube-downscaler-app-dv'||resource.container_name=='cloudsql-proxy-pim-ops-dv'||resource.container_name=='cloudsql-proxy-quotation-engine-ops-dv'||resource.container_name=='cloudsql-proxy-runtime-catalog-ops-dv'||resource.container_name=='cloudsql-proxy-telus-migration-dv')| align rate(5m)| every 5m|condition (value.uptime <  1 )"
}

variable "qry_merlin_Cloud_BSS_Monitoring_diag" {
  type    = string
  default = "fetch k8s_container| metric 'kubernetes.io/container/uptime'| filter (resource.cluster_name =~ '${"^nc\\\\-private\\\\-yul\\\\-.+"}')| filter (resource.container_name=='cassandra-backup-daemon'||resource.container_name=='cassandra-monitoring-agent'||resource.container_name=='cassandra-operator'||resource.container_name=='esc-collector-service'||resource.container_name=='esc-static-service'||resource.container_name=='esc-ui-service'||resource.container_name=='zipkin'||resource.container_name=='zipkin-operator')| align rate(5m)| every 5m|condition (value.uptime <  1 )"
}




resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-catalog-sync-service" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS Cloud Catalog Sync Service"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-CSS.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS Cloud Catalog Sync Service"
    condition_monitoring_query_language {
      query    = var.qry_merlin_Catalog_Sync_Service
      duration = "1800s"
    }
  }
}

resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-core-app" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS Cloud Core"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-Core.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS Cloud core"
    condition_monitoring_query_language {
      query    = var.qry_merlin_Core_App_Alert
      duration = "1800s"
    }
  }
}

resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-core-app2" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS Cloud Core"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-Core.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS Cloud Core2"
    condition_monitoring_query_language {
      query    = var.qry_merlin_Cloud_BSS_Core2
      duration = "1800s"
    }
  }
}

resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-cpq-alert-policy" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS Cloud CPQ"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-CPQ.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS Cloud CPQ"
    condition_monitoring_query_language {
      query    = var.qry_merlin_CPQ_Alert
      duration = "1800s"
    }
  }
}

resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-design-time-catalog-policy" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS Cloud design time catalog"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-DTC.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS Cloud design time catalog"
    condition_monitoring_query_language {
      query    = var.qry_merlin_Design_Time_Catalog
      duration = "1800s"
    }
  }
}

resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-install-base-policy" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS Cloud install base"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-IB.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS Cloud install base"
    condition_monitoring_query_language {
      query    = var.qry_merlin_Install_Base
      duration = "1800s"
    }
  }
}

resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-run-time-catalog-policy" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS run time catalog"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-RTC.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS run time catalog"
    condition_monitoring_query_language {
      query    = var.qry_merlin_Catalog_Sync_Service
      duration = "1800s"
    }
  }
}

resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-core-sql" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS Core SQL"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-Core.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS Core SQL"
    condition_monitoring_query_language {
      query    = var.qry_merlin_Cloud_BSS_Core_SQL
      duration = "1800s"
    }
  }
}

resource "google_monitoring_alert_policy" "merlin-trueSight-cloud-bss-monitoring-diag" {
  project               = var.project_id
  display_name          = "Merlin ${var.env} TrueSight Netcracker Cloud BSS Monitoring"
  notification_channels = [data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = file("${path.module}/Merlin-TS-NC-Monitoring.md")
  }

  conditions {
    display_name = "Merlin TrueSight Netcracker Cloud BSS Monitoring"
    condition_monitoring_query_language {
      query    = var.qry_merlin_Cloud_BSS_Monitoring_diag
      duration = "1800s"
    }
  }
}

