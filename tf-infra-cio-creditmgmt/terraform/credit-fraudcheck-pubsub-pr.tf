#==================Start fraud pr env=================================
#Topic
resource "google_pubsub_topic" "credit-fraud-pr" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-pr-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-fraud-dead_letter-pr" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-pr-dl"
}

resource "google_pubsub_subscription" "credit-fraud-pr-FraudCheckCommandSvc-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-pr[1], google_pubsub_topic.credit-fraud-dead_letter-pr[1]]
  project                 = var.project_id
  name                    = "credit-fraud-pr-FraudCheckCommandSvc-sub"
  topic                   = google_pubsub_topic.credit-fraud-pr[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-fraud-dead_letter-pr[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "credit-fraud-pr-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-dead_letter-pr[1]]
  project                 = var.project_id
  name                    = "credit-fraud-pr-dl-sub"
  topic                   = google_pubsub_topic.credit-fraud-dead_letter-pr[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-fraud-pr-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.credit-fraud-dead_letter-pr[count.index].project
  topic      = google_pubsub_topic.credit-fraud-dead_letter-pr[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-fraud-dead_letter-pr[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-pr-FraudCheckCommandSvc-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-pr-FraudCheckCommandSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-pr-FraudCheckCommandSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-pr-FraudCheckCommandSvc-sub[1]]
}
#==================End fraudcheck pr env=================================
