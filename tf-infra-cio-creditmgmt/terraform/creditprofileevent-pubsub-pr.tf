#==================Start creditprofileevent prd env=================================
#Topic
resource "google_pubsub_topic" "creditprofileevent_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "creditprofileevent_v1.0_prd-tp"
}

# Topic's subscription  ttl ="", the resource never expires. 
resource "google_pubsub_subscription" "creditprofileevent_pubsub_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditprofileevent_pubsub_prd[1]]
  project                 = var.project_id
  name                    = "creditprofileevent_v1.0_prd-sub"
  topic                   = google_pubsub_topic.creditprofileevent_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
#==================End creditprofileevent prd env=================================