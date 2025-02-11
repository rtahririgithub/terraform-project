resource "google_monitoring_custom_service" "orderhub-service" {
  project      = var.project_id
  service_id   = "orderhub-${var.env}"
  display_name = "Order Hub ${var.env}"

  telemetry {
    resource_name = format("%s/namespaces/oe-fifa-portals", local.gke_private_yul_001)
  }
}


#CUJ1 SLI1
resource "google_monitoring_slo" "orderhub_status_ratio" {
  project      = var.project_id
  service      = google_monitoring_custom_service.orderhub-service.service_id
  slo_id       = "csr-availability-slo-${var.env}"
  display_name = "CSR Address Search & Qualification - Availability ${var.env}"

  goal                = 0.999
  rolling_period_days = 28

  #availability = true

  request_based_sli {
    good_total_ratio {
      good_service_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/orderhub-address-request-all\"",
        "metric.label.status < \"500\"",
        "resource.type=\"l7_lb_rule\""

      ])

      total_service_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/orderhub-address-request-all\"",
        "resource.type=\"l7_lb_rule\""
      ])
    }

  }
}

#CUJ1 SLI2
resource "google_monitoring_slo" "orderhub_cuj1_sli2" {
  count        = 0
  project      = var.project_id
  service      = google_monitoring_custom_service.orderhub-service.service_id
  slo_id       = "cuj1-sli2-latency-auto-complete-${var.env}"
  display_name = "Orderhub CUJ1 SLI2 Latency Auto Complete ${var.env}"

  goal                = 0.95
  rolling_period_days = 28



  request_based_sli {
    distribution_cut {
      distribution_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/kong-all-http-code\"",
        "metric.label.consumerName=\"OrderHub_Service_Virtualization\"",
        "metric.label.serviceName=\"AddressManagementRESTSvc_v2_0\"",
        "metric.label.method=\"POST\"",
        "resource.type=\"k8s_container\""
      ])
      range {
        max = 500
      }
    }

  }
}

#CUJ1 SLI3
resource "google_monitoring_slo" "orderhub_cuj1_sli3" {
  count        = 0
  project      = var.project_id
  service      = google_monitoring_custom_service.orderhub-service.service_id
  slo_id       = "cuj1-sli3-latency-address-selection-${var.env}"
  display_name = "Orderhub CUJ1 SLI3 Latency Address Select ${var.env}"

  goal                = 0.95
  rolling_period_days = 28



  request_based_sli {
    distribution_cut {
      distribution_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/kong-all-http-code\"",
        "metric.label.consumerName=\"OrderHub_Service_Virtualization\"",
        "metric.label.serviceName=\"AddressManagementRESTSvc_v2_0\"",
        "metric.label.method=\"GET\"",
        "resource.type=\"k8s_container\""
      ])
      range {
        max = 800
      }
    }

  }
}



#CUJ2 SLI2
resource "google_monitoring_slo" "orderhub_status_ratio_select" {
  project      = var.project_id
  service      = google_monitoring_custom_service.orderhub-service.service_id
  slo_id       = "orderhub-cuj2-sli1-availability-${var.env}"
  display_name = "CUJ2 SLI1 CSR Chooses a Service ${var.env}"

  goal                = 0.999
  rolling_period_days = 28

  #availability = true

  request_based_sli {
    good_total_ratio {
      good_service_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/orderhub-select-request-all\"",
        "metric.label.status < \"500\"",
        "resource.type=\"l7_lb_rule\""

      ])

      total_service_filter = join(" AND ", [
        "metric.type=\"logging.googleapis.com/user/orderhub-select-request-all\"",
        "resource.type=\"l7_lb_rule\""
      ])
    }

  }
}