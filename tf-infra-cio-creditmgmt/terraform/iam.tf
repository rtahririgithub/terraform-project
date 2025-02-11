# Terraform Module for creating the IAM bindings required to allow impersonation of an existing Google Service from GitHub workflows running in the github_repo_names repository.
module "creditmgmt-cicd-wif-iam" {
  count              = var.env == "np" ? 1 : 0
  source             = "git::ssh://git@github.com/telus/tf-module-gcp-wif-iam-binding?ref=v2.0.0"
  service_account_id = "projects/${var.project_id}/serviceAccounts/cicd-service-account@${var.project_id}.iam.gserviceaccount.com"
  github_repo_names = [
    "cio-creditmgmt-cicd-demo-repo",
    "creditmgmt-arch-code-postgresql-template",
    "cio-creditmgmt-writeapi-v2",
    "cio-creditmgmt-getapi-v2",
    "cio-creditmgmt-cp-sync",
    "cio-creditmgmt-asmt-sync",
    "cio-creditmgmt-audit-sync",
    "cio-creditmgmt-account-sync",
    "cio-creditmgmt-audit-purge",
    "cio-creditmgmt-asmt-migration",
    "cio-creditdata-migration",
    "cio-creditmgmt-datamigarationsvc",
    "cdo-test-automation-creditmgmt-wls",
    "sample-java-microservice-1",
    "sample-java-microservice-2",
    "cc-cda-hcd-ruleengine",
    "cc-credit-risk-mgmt-api",
    "cc-cda-tfm-fraudmgmtsvc",
    "cc-cda-fraudvendoradapter",
    "cc-cda-tfm-fraud-check-command-svc"

  ]
}

resource "google_project_iam_member" "cicd_service_account_roles_secretmanager_secretAccessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:cicd-service-account@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cicd_service_account_roles_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:cicd-service-account@${var.project_id}.iam.gserviceaccount.com"
}

# Workload Identity is the recommended way to access GCP services from Kubernetes.
# This module creates:
# GCP Service Account
# IAM Service Account binding to roles/iam.workloadIdentityUser
# Grants the GCP Service Account with the described project roles 
module "creditmgmt-sa-workload-identity" {
  source      = "git::ssh://git@github.com/telus/tf-module-gcp-workload-identity?ref=v0.0.4"
  gsa-name    = "creditmgmt-gsa"
  ksa-name    = "creditmgmt-ksa"
  namespace   = "cio-creditmgmt"
  project_id  = var.project_id
  roles       = ["roles/secretmanager.secretAccessor", "roles/secretmanager.viewer", "roles/cloudsql.client", "roles/cloudsql.instanceUser", "roles/cloudsql.editor", "roles/pubsub.viewer", "roles/pubsub.publisher", "roles/datastore.user", "roles/pubsub.subscriber"]
  cluster_env = "private-nane-${var.env}"
}


# grant permission for Default pub sub service account
resource "google_project_iam_member" "default_perm" {
  project = var.project_id
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:${var.pubsub_default_account}"
}

resource "google_project_iam_member" "storage_perm" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:p854661029070-mhah7m@gcp-sa-cloud-sql.iam.gserviceaccount.com"
}


