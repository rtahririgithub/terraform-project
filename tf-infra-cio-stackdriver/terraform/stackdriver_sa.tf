module "stackdriver_integration_service_account" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-cio-service-accounts?ref=v0.3.0%2Btf.0.13.3"
  project_id   = var.project_id
  display_name = "Stackdriver Integration Service Account"
  account_id   = "stackdriver-integration-sa-${var.env}"
  roles        = ["roles/monitoring.editor"]
}

module "stackdriver_automation_service_account" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-cio-service-accounts?ref=v0.3.0%2Btf.0.13.3"
  project_id   = var.project_id
  display_name = "Stackdriver Automation Service Account"
  account_id   = "stackdriver-automation-sa-${var.env}"
  roles        = ["roles/monitoring.viewer"]
}