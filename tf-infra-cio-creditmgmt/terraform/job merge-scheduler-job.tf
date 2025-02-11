# Dev Merge Trigger
resource "google_cloud_scheduler_job" "merge-trigger-dev" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.merge_pubsub_dv[1]]
  name        = "merge-trigger-dev"
  description = "Merge Job"
  project     = var.project_id
  schedule    = "0 23 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.merge_pubsub_dv[count.index].id
    data       = base64encode("{}")
  }
}

# it01 Merge Trigger
resource "google_cloud_scheduler_job" "merge-trigger-it01" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.merge_pubsub_it01[1]]
  name        = "merge-trigger-it01"
  description = "Merge Job"
  project     = var.project_id
  schedule    = "0 23 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.merge_pubsub_it01[count.index].id
    data       = base64encode("{}")
  }
}

# it02 Merge Trigger
resource "google_cloud_scheduler_job" "merge-trigger-it02" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.merge_pubsub_it02[1]]
  name        = "merge-trigger-it02"
  description = "Merge Job"
  project     = var.project_id
  schedule    = "0 23 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.merge_pubsub_it02[count.index].id
    data       = base64encode("{}")
  }
}

# it03 Merge Trigger
resource "google_cloud_scheduler_job" "merge-trigger-it03" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.merge_pubsub_it03[1]]
  name        = "merge-trigger-it03"
  description = "Merge Job"
  project     = var.project_id
  schedule    = "0 23 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.merge_pubsub_it03[count.index].id
    data       = base64encode("{}")
  }
}
# it04 Merge Trigger
resource "google_cloud_scheduler_job" "merge-trigger-it04" {
  count       = (var.env == "np") ? 1 : 0
  depends_on  = [google_pubsub_topic.merge_pubsub_it04[1]]
  name        = "merge-trigger-it04"
  description = "Merge Job"
  project     = var.project_id
  schedule    = "0 23 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.merge_pubsub_it04[count.index].id
    data       = base64encode("{}")
  }
}
# pr Merge Trigger
resource "google_cloud_scheduler_job" "merge-trigger-pr" {
  count       = (var.env == "pr") ? 1 : 0
  depends_on  = [google_pubsub_topic.merge_pubsub_prd[1]]
  name        = "merge-trigger-prd"
  description = "Merge Job"
  project     = var.project_id
  schedule    = "0 23 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.merge_pubsub_prd[count.index].id
    data       = base64encode("{}")
  }
}