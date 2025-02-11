# Terraform Module for creating the IAM bindings required to allow impersonation of an existing Google Service from GitHub workflows running in the github_repo_names repository.

# Create your Gooogle Service Account. 
#    it is allready created by CCOE onboarding process  

# Grant your Google Service Account the role(s) you need.
#    it is allready created by CCOE onboarding process  ?

# Allow impersonation of the Google Service Account
# from GitHub workflows running in the `your repo` repository.
module "credit-risk-mgmt-cicd-wif-iam" {
  source             = "git::ssh://git@github.com/telus/tf-module-gcp-wif-iam-binding?ref=v2.0.1"
  service_account_id = "projects/${var.project_id}/serviceAccounts/cicd-service-account@${var.project_id}.iam.gserviceaccount.com"
  github_repo_names = [
    "credit-risk-mgmt-test01",
	"credit-risk-mgmt-test02",
  "cc-credit-risk-mgmt-api",
  "cc-credit-risk-mgmt-api-wiremock"

  ]
}

resource "google_project_iam_member" "cicd_service_account_roles_iam_serviceaccountuser" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:cicd-service-account@${var.project_id}.iam.gserviceaccount.com"
}


# Workload Identity is the recommended way to access GCP services from Kubernetes.
# This module creates:
# GCP Service Account
# IAM Service Account binding to roles/iam.workloadIdentityUser
# Grants the GCP Service Account with the described project roles 
module "credit-risk-mgmt-sa-workload-identity" {
  source      = "git::ssh://git@github.com/telus/tf-module-gcp-workload-identity?ref=v0.0.4"
  gsa-name    = "credit-risk-mgmt-gsa"
  ksa-name    = "credit-risk-mgmt-ksa"
  namespace   = "credit-risk-mgmt"
  project_id  = var.project_id
  roles       = ["roles/secretmanager.secretAccessor", "roles/secretmanager.viewer"]
  cluster_env = "private-nane-${var.env}"
}

