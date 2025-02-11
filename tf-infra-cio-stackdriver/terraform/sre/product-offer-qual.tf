resource "google_monitoring_custom_service" "custom-omapi-tmfofferqual-service" {
  project      = var.project_id
  service_id   = "custom-omapi-tmfofferqual-service-${var.env}"
  display_name = "FIFA TMF Offer Qual ${var.env}"

  telemetry {
    resource_name = format("%s/namespaces/cust-om-order-mgmt", local.gke_private_yul_001)
  }
}


#Availability 
resource "google_monitoring_slo" "tmfofferqual-status-ratio" {
  count        = 0
  project      = var.project_id
  service      = google_monitoring_custom_service.orderhub-service.service_id
  slo_id       = "tmf679-availability-slo-${var.env}"
  display_name = "TMF 679 Product Offer Qual availability ${var.env}"

  goal                = 0.99
  rolling_period_days = 28

  #availability = true

  request_based_sli {
    good_total_ratio {
      good_service_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/ordermgmt/offer_qualification/status_code_count_prod\"",
        "metric.label.status_code < \"401\"", //400 valid, >400 not 
        "resource.type=\"k8s_container\""

      ])

      total_service_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/ordermgmt/offer_qualification/status_code_count_prod\"",
        "resource.type=\"k8s_container\""
      ])
    }

  }
}


#Latency 
resource "google_monitoring_slo" "tmfofferqual-latency" {
  count        = 0
  project      = var.project_id
  service      = google_monitoring_custom_service.orderhub-service.service_id
  slo_id       = "tmf679-latency-slo-${var.env}"
  display_name = "TMF 679 Product Offer Qual latency ${var.env}"

  goal                = 0.95
  rolling_period_days = 28


  request_based_sli {
    distribution_cut {
      distribution_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/ordermgmt/offer_qualification/request_latency_prod\"",
        "resource.type=\"k8s_container\""
      ])
      range {
        max = 10000
      }
    }
  }
}