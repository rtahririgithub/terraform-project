module "incident_management_topic" {
  source     = "git::ssh://git@github.com/telus/tf-module-gcp-pubsub?ref=v0.3.0%2Btf.0.13.3"
  project_id = var.project_id
  topic_name = "stackdriver-incident-${var.env}"
}

module "incident_management_service_account" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-cio-service-accounts?ref=v0.3.0%2Btf.0.13.3"
  project_id   = var.project_id
  display_name = "Stackdriver Incident Service Account"
  account_id   = "stackdriver-incident-sa-${var.env}"
  roles        = ["roles/pubsub.publisher", "roles/pubsub.subscriber"]
}
