#==================Start nonfraudcheck dv env=================================
#Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-dv-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-dead_letter-dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-dv-dl"
}

resource "google_pubsub_subscription" "credit-fraud-dv-FraudVendorAdapterSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-dv[1], google_pubsub_topic.credit-nonfraudcheck-dead_letter-dv[1]]
  project                 = var.project_id
  name                    = "credit-fraud-dv-FraudVendorAdapterSvc-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-nonfraudcheck-dead_letter-dv[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "credit-nonfraudcheck-dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-dv[1]]
  project                 = var.project_id
  name                    = "credit-nonfraudcheck-dv-dl-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-dead_letter-dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-nonfraudcheck-dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-nonfraudcheck-dead_letter-dv[count.index].project
  topic      = google_pubsub_topic.credit-nonfraudcheck-dead_letter-dv[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-dv[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-dv-FraudVendorAdapterSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-dv-FraudVendorAdapterSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-dv-FraudVendorAdapterSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-dv-FraudVendorAdapterSvc-sub[1]]
}
#==================End nonfraudcheck dv env=================================
#==================Start nonfraudcheck it01 env=================================
#Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-it01" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-it01-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-dead_letter-it01" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-it01-dl"
}

resource "google_pubsub_subscription" "credit-fraud-it01-FraudVendorAdapterSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-it01[1], google_pubsub_topic.credit-nonfraudcheck-dead_letter-it01[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it01-FraudVendorAdapterSvc-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-it01[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it01[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "credit-nonfraudcheck-it01-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-it01[1]]
  project                 = var.project_id
  name                    = "credit-nonfraudcheck-it01-dl-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it01[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-nonfraudcheck-it01-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it01[count.index].project
  topic      = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it01[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-it01[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-it01-FraudVendorAdapterSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-it01-FraudVendorAdapterSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-it01-FraudVendorAdapterSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-it01-FraudVendorAdapterSvc-sub[1]]
}
#==================End nonfraudcheck it01 env=================================
#==================Start nonfraudcheck it02 env=================================
#Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-it02" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-it02-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-dead_letter-it02" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-it02-dl"
}

resource "google_pubsub_subscription" "credit-fraud-it02-FraudVendorAdapterSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-it02[1], google_pubsub_topic.credit-nonfraudcheck-dead_letter-it02[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it02-FraudVendorAdapterSvc-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-it02[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it02[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "credit-nonfraudcheck-it02-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-it02[1]]
  project                 = var.project_id
  name                    = "credit-nonfraudcheck-it02-dl-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it02[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-nonfraudcheck-it02-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it02[count.index].project
  topic      = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it02[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-it02[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-it02-FraudVendorAdapterSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-it02-FraudVendorAdapterSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-it02-FraudVendorAdapterSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-it02-FraudVendorAdapterSvc-sub[1]]
}
#==================End nonfraudcheck it02 env=================================
#==================Start nonfraudcheck it03 env=================================
#Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-it03" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-it03-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-dead_letter-it03" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-it03-dl"
}

resource "google_pubsub_subscription" "credit-fraud-it03-FraudVendorAdapterSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-it03[1], google_pubsub_topic.credit-nonfraudcheck-dead_letter-it03[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it03-FraudVendorAdapterSvc-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-it03[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it03[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "credit-nonfraudcheck-it03-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-it03[1]]
  project                 = var.project_id
  name                    = "credit-nonfraudcheck-it03-dl-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it03[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-nonfraudcheck-it03-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it03[count.index].project
  topic      = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it03[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-it03[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-it03-FraudVendorAdapterSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-it03-FraudVendorAdapterSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-it03-FraudVendorAdapterSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-it03-FraudVendorAdapterSvc-sub[1]]
}
#==================End nonfraudcheck it03 env=================================
#==================Start nonfraudcheck it04 env=================================
#Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-it04" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-it04-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-nonfraudcheck-dead_letter-it04" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-nonfraudcheck-it04-dl"
}

resource "google_pubsub_subscription" "credit-fraud-it04-FraudVendorAdapterSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-it04[1], google_pubsub_topic.credit-nonfraudcheck-dead_letter-it04[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it04-FraudVendorAdapterSvc-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-it04[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it04[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "credit-nonfraudcheck-it04-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-it04[1]]
  project                 = var.project_id
  name                    = "credit-nonfraudcheck-it04-dl-sub"
  topic                   = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it04[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-nonfraudcheck-it04-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it04[count.index].project
  topic      = google_pubsub_topic.credit-nonfraudcheck-dead_letter-it04[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-nonfraudcheck-dead_letter-it04[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-it04-FraudVendorAdapterSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-it04-FraudVendorAdapterSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-it04-FraudVendorAdapterSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-it04-FraudVendorAdapterSvc-sub[1]]
}
#==================End nonfraudcheck it04 env=================================
