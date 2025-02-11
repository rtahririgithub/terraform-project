#==================Start creditprofileevent DV env=================================
#Topic
resource "google_pubsub_topic" "creditprofileevent_pubsub_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "creditprofileevent_v1.0_dv-tp"
}


# Topic's subscription  ttl ="", the resource never expires. 
resource "google_pubsub_subscription" "creditprofileevent_pubsub_dv-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditprofileevent_pubsub_dv[1]]
  project                 = var.project_id
  name                    = "creditprofileevent_v1.0_dv-sub"
  topic                   = google_pubsub_topic.creditprofileevent_pubsub_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
#==================End creditprofileevent DV env=================================

#==================Start creditprofileevent it02 env=================================
#Topic
resource "google_pubsub_topic" "creditprofileevent_pubsub_it02" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "creditprofileevent_v1.0_it02-tp"
}


# Topic's subscription  ttl ="", the resource never expires. 
resource "google_pubsub_subscription" "creditprofileevent_pubsub_it02-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditprofileevent_pubsub_it02[1]]
  project                 = var.project_id
  name                    = "creditprofileevent_v1.0_it02-sub"
  topic                   = google_pubsub_topic.creditprofileevent_pubsub_it02[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
#==================End creditprofileevent it02 env=================================
#==================Start creditprofileevent it03 env=================================
#Topic
resource "google_pubsub_topic" "creditprofileevent_pubsub_it03" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "creditprofileevent_v1.0_it03-tp"
}


# Topic's subscription  ttl ="", the resource never expires. 
resource "google_pubsub_subscription" "creditprofileevent_pubsub_it03-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditprofileevent_pubsub_it03[1]]
  project                 = var.project_id
  name                    = "creditprofileevent_v1.0_it03-sub"
  topic                   = google_pubsub_topic.creditprofileevent_pubsub_it03[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
#==================End creditprofileevent it03 env=================================
#==================Start creditprofileevent it04 env=================================
#Topic
resource "google_pubsub_topic" "creditprofileevent_pubsub_it04" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "creditprofileevent_v1.0_it04-tp"
}


# Topic's subscription  ttl ="", the resource never expires. 
resource "google_pubsub_subscription" "creditprofileevent_pubsub_it04-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditprofileevent_pubsub_it04[1]]
  project                 = var.project_id
  name                    = "creditprofileevent_v1.0_it04-sub"
  topic                   = google_pubsub_topic.creditprofileevent_pubsub_it04[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
#==================End creditprofileevent it04 env=================================