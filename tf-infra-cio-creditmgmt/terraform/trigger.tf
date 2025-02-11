resource "google_cloudbuild_trigger" "creditmgmt-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.creditmgmt.[v*]"

    repo_name = var.creditmgmt_repo

  }

}

resource "google_cloudbuild_trigger" "creditmgmt-sync-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Sync"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.sync.[v*]"

    repo_name = var.sync_repo

  }

}

resource "google_cloudbuild_trigger" "creditmgmt-integ-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Integration Tests"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.integ.[v*]"

    repo_name = var.integ_repo

  }

}

resource "google_cloudbuild_trigger" "creditmgmt-get-api-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Get API"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.get.[v*]"

    repo_name = var.get_api_repo

  }

}

resource "google_cloudbuild_trigger" "creditmgmt-audit-sync-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Audit Sync"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.audit.[v*]"

    repo_name = var.audit_sync_repo

  }

}

resource "google_cloudbuild_trigger" "creditmgmt-asmt-sync-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Assessment Sync"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.asmt.[v*]"

    repo_name = var.asmt_sync_repo

  }

}

resource "google_cloudbuild_trigger" "creditmgmt-account-sync-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Account Sync"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.account.[v*]"

    repo_name = var.account_sync_repo

  }

}

resource "google_cloudbuild_trigger" "creditmgmt-cp-sync-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Credit Profile Sync"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.cp.[v*]"

    repo_name = var.cp_sync_repo

  }
}

resource "google_cloudbuild_trigger" "creditmgmt-data-migration-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Credit Data Migration"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.datamig.[v*]"

    repo_name = var.cp_data_mig_repo

  }
}

resource "google_cloudbuild_trigger" "creditmgmt-asmt-data-migration-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Credit Assessment Data Migration"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.asmtmig.[v*]"

    repo_name = var.asmt_data_mig_repo

  }
}

resource "google_cloudbuild_trigger" "creditmgmt-audit-purge-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "Credit Management Audit Purge"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.adtpurg.[v*]"

    repo_name = var.audit_purge_repo

  }
}


resource "google_cloudbuild_trigger" "creditmgmt-getapi-v2_repo-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "creditmgmt-getapi-v2_repo"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.getapi-v2.[v*]"

    repo_name = var.creditmgmt-getapi-v2_repo

  }
}

resource "google_cloudbuild_trigger" "creditmgmt-writeapi-v2_repo-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "creditmgmt-writeapi-v2_repo"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.writeapi-v2.[v*]"

    repo_name = var.creditmgmt-writeapi-v2_repo

  }
}


resource "google_cloudbuild_trigger" "cio-creditmgmt-audit-prg-repo-trigger" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id

  description = "cio-creditmgmt-audit-prg-repo"

  filename = "cloudbuild.yaml"

  trigger_template {

    tag_name = "${var.project_name}.audit-prg.[v*]"

    repo_name = var.creditmgmt-audit-prg-repo

  }
}

