#==================Start fraud dv env=================================
#Topic
resource "google_pubsub_topic" "credit-fraud-dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-dv-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-fraud-dead_letter-dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-dv-dl"
}

resource "google_pubsub_subscription" "credit-fraud-dv-FraudCheckCommandSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-dv[1], google_pubsub_topic.credit-fraud-dead_letter-dv[1]]
  project                 = var.project_id
  name                    = "credit-fraud-dv-FraudCheckCommandSvc-sub"
  topic                   = google_pubsub_topic.credit-fraud-dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-fraud-dead_letter-dv[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "credit-fraud-dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-dead_letter-dv[1]]
  project                 = var.project_id
  name                    = "credit-fraud-dv-dl-sub"
  topic                   = google_pubsub_topic.credit-fraud-dead_letter-dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-fraud-dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-fraud-dead_letter-dv[count.index].project
  topic      = google_pubsub_topic.credit-fraud-dead_letter-dv[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-fraud-dead_letter-dv[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-dv-FraudCheckCommandSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-dv-FraudCheckCommandSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-dv-FraudCheckCommandSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-dv-FraudCheckCommandSvc-sub[1]]
}
#==================End fraudcheck dv env=================================
#==================Start fraud it01 env=================================
#Topic
resource "google_pubsub_topic" "credit-fraud-it01" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-it01-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-fraud-dead_letter-it01" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-it01-dl"
}

resource "google_pubsub_subscription" "credit-fraud-it01-FraudCheckCommandSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-it01[1], google_pubsub_topic.credit-fraud-dead_letter-it01[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it01-FraudCheckCommandSvc-sub"
  topic                   = google_pubsub_topic.credit-fraud-it01[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-fraud-dead_letter-it01[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "credit-fraud-it01-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-dead_letter-it01[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it01-dl-sub"
  topic                   = google_pubsub_topic.credit-fraud-dead_letter-it01[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-fraud-it01-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-fraud-dead_letter-it01[count.index].project
  topic      = google_pubsub_topic.credit-fraud-dead_letter-it01[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-fraud-dead_letter-it01[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-it01-FraudCheckCommandSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-it01-FraudCheckCommandSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-it01-FraudCheckCommandSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-it01-FraudCheckCommandSvc-sub[1]]
}
#==================End fraudcheck it01 env=================================
#==================Start fraud it02 env=================================
#Topic
resource "google_pubsub_topic" "credit-fraud-it02" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-it02-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-fraud-dead_letter-it02" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-it02-dl"
}

resource "google_pubsub_subscription" "credit-fraud-it02-FraudCheckCommandSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-it02[1], google_pubsub_topic.credit-fraud-dead_letter-it02[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it02-FraudCheckCommandSvc-sub"
  topic                   = google_pubsub_topic.credit-fraud-it02[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-fraud-dead_letter-it02[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "credit-fraud-it02-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-dead_letter-it02[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it02-dl-sub"
  topic                   = google_pubsub_topic.credit-fraud-dead_letter-it02[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-fraud-it02-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-fraud-dead_letter-it02[count.index].project
  topic      = google_pubsub_topic.credit-fraud-dead_letter-it02[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-fraud-dead_letter-it02[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-it02-FraudCheckCommandSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-it02-FraudCheckCommandSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-it02-FraudCheckCommandSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-it02-FraudCheckCommandSvc-sub[1]]
}
#==================End fraudcheck it02 env=================================
#==================Start fraud it03 env=================================
#Topic
resource "google_pubsub_topic" "credit-fraud-it03" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-it03-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-fraud-dead_letter-it03" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-it03-dl"
}

resource "google_pubsub_subscription" "credit-fraud-it03-FraudCheckCommandSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-it03[1], google_pubsub_topic.credit-fraud-dead_letter-it03[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it03-FraudCheckCommandSvc-sub"
  topic                   = google_pubsub_topic.credit-fraud-it03[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-fraud-dead_letter-it03[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "credit-fraud-it03-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-dead_letter-it03[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it03-dl-sub"
  topic                   = google_pubsub_topic.credit-fraud-dead_letter-it03[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-fraud-it03-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-fraud-dead_letter-it03[count.index].project
  topic      = google_pubsub_topic.credit-fraud-dead_letter-it03[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-fraud-dead_letter-it03[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-it03-FraudCheckCommandSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-it03-FraudCheckCommandSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-it03-FraudCheckCommandSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-it03-FraudCheckCommandSvc-sub[1]]
}
#==================End fraudcheck it03 env=================================
#==================Start fraud it04 env=================================
#Topic
resource "google_pubsub_topic" "credit-fraud-it04" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-it04-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "credit-fraud-dead_letter-it04" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-fraud-it04-dl"
}

resource "google_pubsub_subscription" "credit-fraud-it04-FraudCheckCommandSvc-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-it04[1], google_pubsub_topic.credit-fraud-dead_letter-it04[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it04-FraudCheckCommandSvc-sub"
  topic                   = google_pubsub_topic.credit-fraud-it04[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.credit-fraud-dead_letter-it04[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "credit-fraud-it04-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.credit-fraud-dead_letter-it04[1]]
  project                 = var.project_id
  name                    = "credit-fraud-it04-dl-sub"
  topic                   = google_pubsub_topic.credit-fraud-dead_letter-it04[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "credit-fraud-it04-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.credit-fraud-dead_letter-it04[count.index].project
  topic      = google_pubsub_topic.credit-fraud-dead_letter-it04[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.credit-fraud-dead_letter-it04[1]]
}



# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "credit-fraud-it04-FraudCheckCommandSvc-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.credit-fraud-it04-FraudCheckCommandSvc-sub[count.index].project
  subscription = google_pubsub_subscription.credit-fraud-it04-FraudCheckCommandSvc-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.credit-fraud-it04-FraudCheckCommandSvc-sub[1]]
}
#==================End fraudcheck it04 env=================================

