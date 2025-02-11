module "service_account" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-cio-service-accounts?ref=v0.4.0%2Btf.0.14.9"
  project_id   = var.project_id
  display_name = "GCP Groups Management"
  account_id   = var.gcp_group_mgmt_accnt_id
  roles        = ["roles/serviceusage.serviceUsageConsumer"]
}


# data "google_service_account_access_token" "gcp-groups-management" {
#   target_service_account = module.service_account.email
#   scopes = [
#     "https://www.googleapis.com/auth/admin.directory.user",
#     "https://www.googleapis.com/auth/admin.directory.domain.readonly",
#     "userinfo-email",
#     "cloud-platform",
#   ]
#   lifetime = "300s"
# }

# output "token" {
#   value = data.google_service_account_access_token.gcp-groups-management.lifetime
# }

resource "google_service_account_iam_binding" "token_creator_iam" {
  service_account_id = module.service_account.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = var.gcp_group_management_sa_token_creators
  depends_on         = [module.service_account]
}

resource "google_service_account_iam_binding" "workload_identity_user" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.gcp_group_mgmt_accnt_id}@${var.project_id}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:cdo-namespace-factory-pr-e911.svc.id.goog[cnrm-system/cnrm-controller-manager-gcp-groups-mgmt]",
    "serviceAccount:cdo-cfg-ctrl-factory-pr-7e1f9f.svc.id.goog[cnrm-system/cnrm-controller-manager-gcp-groups-mgmt]",
    "serviceAccount:gitops-sa@${var.project_id}.iam.gserviceaccount.com",
    "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
  ]
  depends_on = [module.service_account]
}
