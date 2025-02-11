resource "google_monitoring_custom_service" "customsrv" {
  project      = var.project_id
  service_id   = "custom-srv-request-slos"
  display_name = "Custom-Service"

  telemetry {
    resource_name = format("%s/namespaces/dt-cons-customer-assist", local.gke_private_yul_001)
  }
}

#Availability
resource "google_monitoring_slo" "request_based_slo" {
  count        = 0
  project      = var.project_id
  service      = google_monitoring_custom_service.customsrv.service_id
  slo_id       = "customsrv-availability-slo"
  display_name = "Terraform Test SLO with request based SLI (good total ratio)"

  goal                = 0.99
  rolling_period_days = 28

  request_based_sli {
    good_total_ratio {
      good_service_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/customsrv/wireless-subscription-gql/status_code_count_prod\"",
        "metric.label.status_code < \"401\"", //400 valid, >400 not 
        "resource.type=\"k8s_container\""

      ])

      total_service_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/customsrv/wireless-subscription-gql/status_code_count_prod\"",
        "resource.type=\"k8s_container\""
      ])
    }
  }
}


#Latency 
resource "google_monitoring_slo" "customsrv-latency" {
  count        = 0
  project      = var.project_id
  service      = google_monitoring_custom_service.customsrv.service_id
  slo_id       = "customsrv-latency-slo"
  display_name = "customsrv latency"

  goal                = 0.95
  rolling_period_days = 28


  request_based_sli {
    distribution_cut {
      distribution_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/customsrv/wireless-subscription-gql/request_latency_prod\"",
        "resource.type=\"k8s_container\""
      ])
      range {
        max = 10000
      }
    }
  }
}
