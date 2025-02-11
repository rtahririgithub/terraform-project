locals {
  # tag_builds  = var.env == "pr" ? var.builds : {}
  tag_builds  = var.builds
  push_builds = var.env == "np" ? var.builds : {}
  auto_builds = var.env == "pr" ? var.builds : {}
}


resource "google_cloudbuild_trigger" "push" {
  for_each    = local.push_builds
  project     = var.project_id
  name        = "StackdriverMonitoring-${each.value.name}-Push"
  description = "Stackdriver Monitoring - ${each.value.name} - Push"
  filename    = "cloud-build/tf-apply-project.yaml"

  #Due to this issue https://github.com/terraform-providers/terraform-provider-google/issues/1950
  #DO NOT ADD DIASABLED

  trigger_template {
    branch_name = "master"
    repo_name   = "github_telus_tf-infra-cio-stackdriver"
  }
  included_files = ["terraform/${lower(each.value.name)}/**"]
  substitutions = {
    _STRATEGY              = "push"
    _TF_DIR                = "terraform/${lower(each.value.name)}/${var.env}"
    _BACKEND_CONFIG_PREFIX = "prefix=terraform/${var.env}/${lower(each.value.name)}"
    _VAR_FILE              = "/workspace/terraform/${var.env}.tfvars"
    _TF_OPTIONS            = "-auto-approve .."
    _TF_INIT_OPTIONS       = ".."
    _TF_LOG                = ""
  }
}


resource "google_cloudbuild_trigger" "tag" {
  for_each    = local.tag_builds
  project     = var.project_id
  name        = "StackdriverMonitoring-${each.value.name}-Tag"
  description = "Stackdriver Monitoring - ${each.value.name} - Tag"
  filename    = "cloud-build/tf-apply-project.yaml"

  #Due to this issue https://github.com/terraform-providers/terraform-provider-google/issues/1950
  #DO NOT ADD DIASABLED

  trigger_template {
    tag_name  = "cio-stack-driver-${var.env}-${lower(each.value.name)}.[v*]"
    repo_name = "github_telus_tf-infra-cio-stackdriver"
  }
  included_files = ["terraform/${lower(each.value.name)}/**"]
  substitutions = {
    _STRATEGY              = "push"
    _TF_DIR                = "terraform/${lower(each.value.name)}/${var.env}"
    _BACKEND_CONFIG_PREFIX = "prefix=terraform/${var.env}/${lower(each.value.name)}"
    _VAR_FILE              = "/workspace/terraform/${var.env}.tfvars"
    _TF_OPTIONS            = "-auto-approve .."
    _TF_INIT_OPTIONS       = ".."
    _TF_LOG                = ""
  }
}

resource "google_cloudbuild_trigger" "auto-tag" {
  for_each    = local.auto_builds
  project     = var.project_id
  name        = "StackdriverMonitoring-${each.value.name}-Auto-Tag"
  description = "Stackdriver Monitoring - ${each.value.name} - Auto -Tag"
  filename    = "cloud-build/tf-apply-project.yaml"

  #Due to this issue https://github.com/terraform-providers/terraform-provider-google/issues/1950
  #DO NOT ADD DIASABLED

  trigger_template {
    tag_name  = "cio-stack-driver-${var.env}-${lower(each.value.name)}.auto.\\d{4}\\-(0?[1-9]|1[012])\\-(0?[1-9]|[12][0-9]|3[01])$"
    repo_name = "github_telus_tf-infra-cio-stackdriver"
  }
  included_files = ["terraform/${lower(each.value.name)}/**"]
  substitutions = {
    _STRATEGY              = "push"
    _TF_DIR                = "terraform/${lower(each.value.name)}/${var.env}"
    _BACKEND_CONFIG_PREFIX = "prefix=terraform/${var.env}/${lower(each.value.name)}"
    _VAR_FILE              = "/workspace/terraform/${var.env}.tfvars"
    _TF_OPTIONS            = "-auto-approve .."
    _TF_INIT_OPTIONS       = ".."
    _TF_LOG                = ""
  }
}
