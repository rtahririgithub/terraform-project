resource "google_pubsub_topic" "profile_pubsub" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_dv-tp"
}

# Dead letter Topic
resource "google_pubsub_topic" "profile_pubsub_dead_letter" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_dv-dl"
}


resource "google_pubsub_subscription" "profile_pubsub_dv-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub[1], google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_dv-sub"
  topic                   = google_pubsub_topic.profile_pubsub[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.profile_pubsub_dead_letter[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "profile_pubsub_dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_dv-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "profile_pubsub_dv-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.profile_pubsub_dv-sub[count.index].project
  subscription = google_pubsub_subscription.profile_pubsub_dv-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.profile_pubsub_dv-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "profile_pubsub_dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}

# Credit Profile IT03

resource "google_pubsub_topic" "profile_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_it03-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "profile_pubsub_dead_letter_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_it03-dl"
}

resource "google_pubsub_subscription" "profile_pubsub_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_testing[1], google_pubsub_topic.profile_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_it03-sub"
  topic                   = google_pubsub_topic.profile_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.profile_pubsub_dead_letter_testing[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "profile_pubsub_testing-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_it03-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "profile_pubsub_testing-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.profile_pubsub_testing-sub[count.index].project
  subscription = google_pubsub_subscription.profile_pubsub_testing-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.profile_pubsub_testing-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "profile_pubsub_testing-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}

# Credit Profile IT04

resource "google_pubsub_topic" "profile_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_it04-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "profile_pubsub_dead_letter_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_it04-dl"
}

resource "google_pubsub_subscription" "profile_pubsub_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_staging[1], google_pubsub_topic.profile_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_it04-sub"
  topic                   = google_pubsub_topic.profile_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.profile_pubsub_dead_letter_staging[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "profile_pubsub_staging-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_it04-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "profile_pubsub_staging-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.profile_pubsub_staging-sub[count.index].project
  subscription = google_pubsub_subscription.profile_pubsub_staging-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.profile_pubsub_staging-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "profile_pubsub_staging-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}


# Assessment dev

resource "google_pubsub_topic" "assessment_pubsub" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_dv-tp"
}

resource "google_pubsub_topic" "assessment_pubsub_dead_letter" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_dv-dl"
}

resource "google_pubsub_subscription" "last_assessment_dv-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub[1], google_pubsub_topic.assessment_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_dv-sub"
  topic                   = google_pubsub_topic.assessment_pubsub[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.assessment_pubsub_dead_letter[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "last_assessment_dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_dv-dl-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "last_assessment_dv-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.last_assessment_dv-sub[count.index].project
  subscription = google_pubsub_subscription.last_assessment_dv-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.last_assessment_dv-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "last_assessment_dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.assessment_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.assessment_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.assessment_pubsub_dead_letter[1]]
}

# Assessment pubSub IT03

resource "google_pubsub_topic" "assessment_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_it03-tp"
}

resource "google_pubsub_topic" "assessment_pubsub_dead_letter_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_it03-dl"
}

resource "google_pubsub_subscription" "last_assessment_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_testing[1], google_pubsub_topic.assessment_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_it03-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.assessment_pubsub_dead_letter_testing[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "last_assessment_testing-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_it03-dl-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_dead_letter_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "last_assessment_testing-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.last_assessment_testing-sub[count.index].project
  subscription = google_pubsub_subscription.last_assessment_testing-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.last_assessment_testing-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "last_assessment_testing-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.assessment_pubsub_dead_letter_testing[count.index].project
  topic      = google_pubsub_topic.assessment_pubsub_dead_letter_testing[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.assessment_pubsub_dead_letter_testing[1]]
}

# Assessment pubSub IT04

resource "google_pubsub_topic" "assessment_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_it04-tp"
}

resource "google_pubsub_topic" "assessment_pubsub_dead_letter_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_it04-dl"
}

resource "google_pubsub_subscription" "last_assessment_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_staging[1], google_pubsub_topic.assessment_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_it04-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.assessment_pubsub_dead_letter_staging[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "last_assessment_staging-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_it04-dl-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_dead_letter_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "last_assessment_staging-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.last_assessment_staging-sub[count.index].project
  subscription = google_pubsub_subscription.last_assessment_staging-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.last_assessment_staging-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "last_assessment_staging-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.assessment_pubsub_dead_letter_staging[count.index].project
  topic      = google_pubsub_topic.assessment_pubsub_dead_letter_staging[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.assessment_pubsub_dead_letter_staging[1]]
}


# X_CONV_START IT03
resource "google_pubsub_topic" "xconv_start_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "xconv_start_it03-tp"
}

resource "google_pubsub_subscription" "xconv_start_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_start_pubsub_testing[1]]
  project                 = var.project_id
  name                    = "xconv_start_it03-sub"
  topic                   = google_pubsub_topic.xconv_start_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# X_CONV_START IT04
resource "google_pubsub_topic" "xconv_start_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "xconv_start_it04-tp"
}

resource "google_pubsub_subscription" "xconv_start_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_start_pubsub_staging[1]]
  project                 = var.project_id
  name                    = "xconv_start_it04-sub"
  topic                   = google_pubsub_topic.xconv_start_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# X_CONV_ASMT_START IT03
resource "google_pubsub_topic" "xconv_asmt_start_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "xconv_asmt_start_it03-tp"
}

resource "google_pubsub_subscription" "xconv_asmt_start_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_asmt_start_pubsub_testing[1]]
  project                 = var.project_id
  name                    = "xconv_asmt_start_it03-sub"
  topic                   = google_pubsub_topic.xconv_asmt_start_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# X_CONV_ASMT_START IT04
resource "google_pubsub_topic" "xconv_asmt_start_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "xconv_asmt_start_it04-tp"
}

resource "google_pubsub_subscription" "xconv_asmt_start_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_asmt_start_pubsub_staging[1]]
  project                 = var.project_id
  name                    = "xconv_asmt_start_it04-sub"
  topic                   = google_pubsub_topic.xconv_asmt_start_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}


# X_CONV_CUST_TO_PROCESS IT03
resource "google_pubsub_topic" "xconv_cust_to_process_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "x_conv_cust_to_process_it03-tp"
}

resource "google_pubsub_topic" "xconv_cust_to_process_dead_letter_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "x_conv_cust_to_process_it03-dl"
}

resource "google_pubsub_subscription" "x_conv_cust_to_process_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_cust_to_process_pubsub_testing[1], google_pubsub_topic.xconv_cust_to_process_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "x_conv_cust_to_process_it03-sub"
  topic                   = google_pubsub_topic.xconv_cust_to_process_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 600
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.xconv_cust_to_process_dead_letter_testing[count.index].id
    max_delivery_attempts = 0
  }
}

# dead letter sub
resource "google_pubsub_subscription" "x_conv_cust_to_process_testing-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_cust_to_process_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "x_conv_cust_to_process_it03-dl-sub"
  topic                   = google_pubsub_topic.xconv_cust_to_process_dead_letter_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "x_conv_cust_to_process_testing-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.x_conv_cust_to_process_testing-sub[count.index].project
  subscription = google_pubsub_subscription.x_conv_cust_to_process_testing-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.x_conv_cust_to_process_testing-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "x_conv_cust_to_process_testing-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.xconv_cust_to_process_dead_letter_testing[count.index].project
  topic      = google_pubsub_topic.xconv_cust_to_process_dead_letter_testing[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.xconv_cust_to_process_dead_letter_testing[1]]
}


# X_CONV_CUST_TO_PROCESS IT04
resource "google_pubsub_topic" "xconv_cust_to_process_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "x_conv_cust_to_process_it04-tp"
}

resource "google_pubsub_topic" "xconv_cust_to_process_dead_letter_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "x_conv_cust_to_process_it04-dl"
}

resource "google_pubsub_subscription" "x_conv_cust_to_process_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_cust_to_process_pubsub_staging[1], google_pubsub_topic.xconv_cust_to_process_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "x_conv_cust_to_process_it04-sub"
  topic                   = google_pubsub_topic.xconv_cust_to_process_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 600
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.xconv_cust_to_process_dead_letter_staging[count.index].id
    max_delivery_attempts = 0
  }
}

# dead letter sub
resource "google_pubsub_subscription" "x_conv_cust_to_process_staging-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_cust_to_process_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "x_conv_cust_to_process_it04-dl-sub"
  topic                   = google_pubsub_topic.xconv_cust_to_process_dead_letter_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "x_conv_cust_to_process_staging-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.x_conv_cust_to_process_staging-sub[count.index].project
  subscription = google_pubsub_subscription.x_conv_cust_to_process_staging-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.x_conv_cust_to_process_staging-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "x_conv_cust_to_process_staging-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.xconv_cust_to_process_dead_letter_staging[count.index].project
  topic      = google_pubsub_topic.xconv_cust_to_process_dead_letter_staging[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.xconv_cust_to_process_dead_letter_staging[1]]
}




# NoSQL CreditProfileDoc Sync -- Dev
resource "google_pubsub_topic" "cp_doc_sync_pubsub_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_dv-tp"
}

resource "google_pubsub_topic" "cp_doc_sync_pubsub_dead_letter_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_dv-dl"
}

resource "google_pubsub_subscription" "cp_doc_sync_dv-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_dv[1], google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_dv-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_dv[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_doc_sync_dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_dv-dl-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_doc_sync_dv-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_doc_sync_dv-sub[count.index].project
  subscription = google_pubsub_subscription.cp_doc_sync_dv-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_doc_sync_dv-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_doc_sync_dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_dv[count.index].project
  topic      = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_dv[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_dv[1]]
}

# NoSQL CreditProfileDoc Sync -- IT03
resource "google_pubsub_topic" "cp_doc_sync_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_it03-tp"
}

resource "google_pubsub_topic" "cp_doc_sync_pubsub_dead_letter_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_it03-dl"
}

resource "google_pubsub_subscription" "cp_doc_sync_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_testing[1], google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_it03-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_testing[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "cp_doc_sync_testing-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_it03-dl-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_doc_sync_testing-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_doc_sync_testing-sub[count.index].project
  subscription = google_pubsub_subscription.cp_doc_sync_testing-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_doc_sync_testing-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_doc_sync_testing-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_testing[count.index].project
  topic      = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_testing[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_testing[1]]
}

# NoSQL CreditProfileDoc Sync -- IT04
resource "google_pubsub_topic" "cp_doc_sync_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_it04-tp"
}

resource "google_pubsub_topic" "cp_doc_sync_pubsub_dead_letter_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_it04-dl"
}

resource "google_pubsub_subscription" "cp_doc_sync_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_staging[1], google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_it04-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_staging[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "cp_doc_sync_staging-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_it04-dl-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_doc_sync_staging-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_doc_sync_staging-sub[count.index].project
  subscription = google_pubsub_subscription.cp_doc_sync_staging-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_doc_sync_staging-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_doc_sync_staging-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_staging[count.index].project
  topic      = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_staging[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_staging[1]]
}




# NoSQL Audit Sync -- Dev
resource "google_pubsub_topic" "cp_audit_pubsub_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_dv-tp"
}

resource "google_pubsub_topic" "cp_audit_pubsub_dead_letter_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_dv-dl"
}

resource "google_pubsub_subscription" "cp_audit_dv-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_dv[1], google_pubsub_topic.cp_audit_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_dv-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_pubsub_dead_letter_dv[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "cp_audit_dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_dv-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_dead_letter_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_dv-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_dv-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_dv-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_dv-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_pubsub_dead_letter_dv[count.index].project
  topic      = google_pubsub_topic.cp_audit_pubsub_dead_letter_dv[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_pubsub_dead_letter_dv[1]]
}


# NoSQL Audit Sync -- IT03
resource "google_pubsub_topic" "cp_audit_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_it03-tp"
}

resource "google_pubsub_topic" "cp_audit_pubsub_dead_letter_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_it03-dl"
}

resource "google_pubsub_subscription" "cp_audit_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_testing[1], google_pubsub_topic.cp_audit_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_it03-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_pubsub_dead_letter_testing[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "cp_audit_testing-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_it03-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_dead_letter_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_testing-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_testing-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_testing-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_testing-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_testing-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_pubsub_dead_letter_testing[count.index].project
  topic      = google_pubsub_topic.cp_audit_pubsub_dead_letter_testing[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_pubsub_dead_letter_testing[1]]
}

# NoSQL Audit Sync -- IT04
resource "google_pubsub_topic" "cp_audit_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_it04-tp"
}

resource "google_pubsub_topic" "cp_audit_pubsub_dead_letter_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_it04-dl"
}

resource "google_pubsub_subscription" "cp_audit_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_staging[1], google_pubsub_topic.cp_audit_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_it04-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_pubsub_dead_letter_staging[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_audit_staging-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_it04-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_dead_letter_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_staging-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_staging-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_staging-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_staging-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_staging-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_pubsub_dead_letter_staging[count.index].project
  topic      = google_pubsub_topic.cp_audit_pubsub_dead_letter_staging[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_pubsub_dead_letter_staging[1]]
}





# NoSQL Account Sync -- Dev
resource "google_pubsub_topic" "account_pubsub_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_dv-tp"
}

resource "google_pubsub_topic" "account_pubsub_dead_letter_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_dv-dl"
}

resource "google_pubsub_subscription" "account_dv-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_dv[1], google_pubsub_topic.account_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "account_v1.0_dv-sub"
  topic                   = google_pubsub_topic.account_pubsub_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.account_pubsub_dead_letter_dv[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "account_dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "account_v1.0_dv-dl-sub"
  topic                   = google_pubsub_topic.account_pubsub_dead_letter_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "account_dv-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.account_dv-sub[count.index].project
  subscription = google_pubsub_subscription.account_dv-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.account_dv-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "account_dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.account_pubsub_dead_letter_dv[count.index].project
  topic      = google_pubsub_topic.account_pubsub_dead_letter_dv[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.account_pubsub_dead_letter_dv[1]]
}


# NoSQL Account Sync -- IT03
resource "google_pubsub_topic" "account_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_it03-tp"
}

resource "google_pubsub_topic" "account_pubsub_dead_letter_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_it03-dl"
}

resource "google_pubsub_subscription" "account_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_testing[1], google_pubsub_topic.account_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "account_v1.0_it03-sub"
  topic                   = google_pubsub_topic.account_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.account_pubsub_dead_letter_testing[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "account_testing-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "account_v1.0_it03-dl-sub"
  topic                   = google_pubsub_topic.account_pubsub_dead_letter_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "account_testing-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.account_testing-sub[count.index].project
  subscription = google_pubsub_subscription.account_testing-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.account_testing-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "account_testing-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.account_pubsub_dead_letter_testing[count.index].project
  topic      = google_pubsub_topic.account_pubsub_dead_letter_testing[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.account_pubsub_dead_letter_testing[1]]
}


# NoSQL Account Sync -- IT04
resource "google_pubsub_topic" "account_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_it04-tp"
}

resource "google_pubsub_topic" "account_pubsub_dead_letter_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_it04-dl"
}

resource "google_pubsub_subscription" "account_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_staging[1], google_pubsub_topic.account_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "account_v1.0_it04-sub"
  topic                   = google_pubsub_topic.account_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.account_pubsub_dead_letter_staging[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "account_staging-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "account_v1.0_it04-dl-sub"
  topic                   = google_pubsub_topic.account_pubsub_dead_letter_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "account_staging-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.account_staging-sub[count.index].project
  subscription = google_pubsub_subscription.account_staging-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.account_staging-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "account_staging-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.account_pubsub_dead_letter_staging[count.index].project
  topic      = google_pubsub_topic.account_pubsub_dead_letter_staging[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.account_pubsub_dead_letter_staging[1]]
}





# NoSQL CreditChange -- Dev
resource "google_pubsub_topic" "creditchange_pubsub_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_dv-tp"
}

resource "google_pubsub_topic" "creditchange_pubsub_dead_letter_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_dv-dl"
}

resource "google_pubsub_subscription" "creditchange_dv-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_dv[1], google_pubsub_topic.creditchange_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_dv-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.creditchange_pubsub_dead_letter_dv[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "creditchange_dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_dv-dl-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_dead_letter_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "creditchange_dv-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.creditchange_dv-sub[count.index].project
  subscription = google_pubsub_subscription.creditchange_dv-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.creditchange_dv-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "creditchange_dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.creditchange_pubsub_dead_letter_dv[count.index].project
  topic      = google_pubsub_topic.creditchange_pubsub_dead_letter_dv[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.creditchange_pubsub_dead_letter_dv[1]]
}


# NoSQL CreditChange -- IT03
resource "google_pubsub_topic" "creditchange_pubsub_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_it03-tp"
}

resource "google_pubsub_topic" "creditchange_pubsub_dead_letter_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_it03-dl"
}

resource "google_pubsub_subscription" "creditchange_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_testing[1], google_pubsub_topic.creditchange_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_it03-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.creditchange_pubsub_dead_letter_testing[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "creditchange_testing-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_it03-dl-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_dead_letter_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "creditchange_testing-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.creditchange_testing-sub[count.index].project
  subscription = google_pubsub_subscription.creditchange_testing-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.creditchange_testing-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "creditchange_testing-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.creditchange_pubsub_dead_letter_testing[count.index].project
  topic      = google_pubsub_topic.creditchange_pubsub_dead_letter_testing[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.creditchange_pubsub_dead_letter_testing[1]]
}


# NoSQL CreditChange -- IT04
resource "google_pubsub_topic" "creditchange_pubsub_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_it04-tp"
}

resource "google_pubsub_topic" "creditchange_pubsub_dead_letter_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_it04-dl"
}

resource "google_pubsub_subscription" "creditchange_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_staging[1], google_pubsub_topic.creditchange_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_it04-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.creditchange_pubsub_dead_letter_staging[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "creditchange_staging-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_it04-dl-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_dead_letter_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "creditchange_staging-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.creditchange_staging-sub[count.index].project
  subscription = google_pubsub_subscription.creditchange_staging-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.creditchange_staging-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "creditchange_staging-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.creditchange_pubsub_dead_letter_staging[count.index].project
  topic      = google_pubsub_topic.creditchange_pubsub_dead_letter_staging[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.creditchange_pubsub_dead_letter_staging[1]]
}


# CP Audit Purge Dev

resource "google_pubsub_topic" "cp_audit_purge_dev" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_dv-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "cp_audit_purge_dead_letter_dev" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_dv-dl"
}

resource "google_pubsub_subscription" "cp_audit_purge_dev-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_dev[1], google_pubsub_topic.cp_audit_purge_dead_letter_dev[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_dv-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_dev[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_purge_dead_letter_dev[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_audit_purge_dev-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_dead_letter_dev[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_dv-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_dead_letter_dev[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_purge_dev-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_purge_dev-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_purge_dev-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_purge_dev-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_purge_dev-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_purge_dead_letter_dev[count.index].project
  topic      = google_pubsub_topic.cp_audit_purge_dead_letter_dev[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_purge_dead_letter_dev[1]]
}

# CP Audit Purge IT03

resource "google_pubsub_topic" "cp_audit_purge_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_it03-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "cp_audit_purge_dead_letter_testing" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_it03-dl"
}

resource "google_pubsub_subscription" "cp_audit_purge_testing-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_testing[1], google_pubsub_topic.cp_audit_purge_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_it03-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_purge_dead_letter_testing[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_audit_purge_testing-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_dead_letter_testing[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_it03-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_dead_letter_testing[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_purge_testing-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_purge_testing-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_purge_testing-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_purge_testing-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_purge_testing-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_purge_dead_letter_testing[count.index].project
  topic      = google_pubsub_topic.cp_audit_purge_dead_letter_testing[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_purge_dead_letter_testing[1]]
}

# CP Audit Purge IT04

resource "google_pubsub_topic" "cp_audit_purge_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_it04-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "cp_audit_purge_dead_letter_staging" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_it04-dl"
}

resource "google_pubsub_subscription" "cp_audit_purge_staging-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_staging[1], google_pubsub_topic.cp_audit_purge_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_it04-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_purge_dead_letter_staging[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_audit_purge_staging-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_dead_letter_staging[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_it04-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_dead_letter_staging[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_purge_staging-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_purge_staging-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_purge_staging-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_purge_staging-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_purge_staging-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_purge_dead_letter_staging[count.index].project
  topic      = google_pubsub_topic.cp_audit_purge_dead_letter_staging[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_purge_dead_letter_staging[1]]
}


# Credit Profile it01

resource "google_pubsub_topic" "profile_pubsub_it01" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_it01-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "profile_pubsub_dead_letter_it01" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_it01-dl"
}

resource "google_pubsub_subscription" "profile_pubsub_it01-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_it01[1], google_pubsub_topic.profile_pubsub_dead_letter_it01[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_it01-sub"
  topic                   = google_pubsub_topic.profile_pubsub_it01[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.profile_pubsub_dead_letter_it01[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "profile_pubsub_it01-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_it01-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "profile_pubsub_it01-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.profile_pubsub_it01-sub[count.index].project
  subscription = google_pubsub_subscription.profile_pubsub_it01-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.profile_pubsub_it01-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "profile_pubsub_it01-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}