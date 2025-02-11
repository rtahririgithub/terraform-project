resource "google_project_iam_member" "git_ops_secret_manager" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:cio-git-ops-read@cio-service-accounts-pr-ef4f79.iam.gserviceaccount.com"
}

module "service_account" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-cio-service-accounts?ref=v0.3.0%2Btf.0.13.3"
  project_id   = var.project_id
  display_name = "GitOps Service Account"
  account_id   = var.git_ops_account_id
  roles        = ["roles/cloudbuild.builds.builder", "roles/logging.viewer", "roles/viewer"]
}

module "github-wif-iam" {
  source             = "git::ssh://git@github.com/telus/tf-module-gcp-wif-iam-binding?ref=v2.0.0"
  service_account_id = module.service_account.name
  github_repo_names  = ["tf-infra-cio-stackdriver"]
}