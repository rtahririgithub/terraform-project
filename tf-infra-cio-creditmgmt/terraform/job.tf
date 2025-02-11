# Dev Audit-Purge Trigger
resource "google_cloud_scheduler_job" "job" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.cp_audit_purge_dev[1]]
  name        = "audit-purge-trigger"
  description = "Audit Logs purge Job"
  project     = var.project_id
  schedule    = "0 7 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.cp_audit_purge_dev[count.index].id
    data       = base64encode("{}")
  }
}

# IT02 Audit-Purge Trigger
resource "google_cloud_scheduler_job" "job_qa" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.cp_audit_purge_qa[1]]
  name        = "audit-purge-trigger-it02"
  description = "Audit Logs purge Job"
  project     = var.project_id
  schedule    = "0 7 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.cp_audit_purge_qa[count.index].id
    data       = base64encode("{}")
  }
}

# IT03 Audit-Purge Trigger
resource "google_cloud_scheduler_job" "job_testing" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.cp_audit_purge_testing[1]]
  name        = "audit-purge-trigger-it03"
  description = "Audit Logs purge Job"
  project     = var.project_id
  schedule    = "0 7 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.cp_audit_purge_testing[count.index].id
    data       = base64encode("{}")
  }
}

# IT04 Audit-Purge Trigger
resource "google_cloud_scheduler_job" "job_staging" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.cp_audit_purge_staging[1]]
  name        = "audit-purge-trigger-it04"
  description = "Audit Logs purge Job"
  project     = var.project_id
  schedule    = "0 7 1 * *"

  pubsub_target {
    topic_name = google_pubsub_topic.cp_audit_purge_staging[count.index].id
    data       = base64encode("{}")
  }
}

# PROD Audit-Purge Trigger
resource "google_cloud_scheduler_job" "job_prd" {
  count       = (var.env == "pr") ? 1 : 0
  depends_on  = [google_pubsub_topic.cp_audit_purge_prd[1]]
  name        = "audit-purge-trigger"
  description = "Audit Logs purge Job"
  project     = var.project_id
  schedule    = "0 7 1 * *"

  pubsub_target {
    topic_name = google_pubsub_topic.cp_audit_purge_prd[count.index].id
    data       = base64encode("{}")
  }
}