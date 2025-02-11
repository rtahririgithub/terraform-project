module "github-wif-iam" {
  source             = "git::ssh://git@github.com/telus/tf-module-gcp-wif-iam-binding?ref=v2.0.1"
  service_account_id = module.gitops_service_account.name
  github_repo_names  = ["tf-infra-gcp-groups"]
}

module "gitops_service_account" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-cio-service-accounts?ref=v0.3.0%2Btf.0.13.3"
  project_id   = var.project_id
  display_name = "GitOps Service Account"
  account_id   = var.git_ops_account_id
  roles        = ["roles/cloudbuild.builds.builder", "roles/logging.viewer", "roles/viewer", "roles/storage.admin"]
}
