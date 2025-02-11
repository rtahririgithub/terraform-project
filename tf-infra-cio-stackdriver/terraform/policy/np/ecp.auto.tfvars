# the environment variables for the ECP project

database_id = "cio-notification-np-93822f:communication-message-np"

ecp_project_id = "cio-notification-np-93822f"

wnp_processor_log_url = "https://console.cloud.google.com/logs/query;query=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-9ed5d0%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-np-001%22%0Aresource.labels.namespace_name%3D%22notify-communication%22%0Alabels.k8s-pod%2Fapp%3D%22notify-wnp-processor-dv%22%0Aseverity%3DERROR?project=cio-gke-private-yul-001-9ed5d0"

custbill_retrieval_log_url = "https://console.cloud.google.com/logs/query;query=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-9ed5d0%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-np-001%22%0Aresource.labels.namespace_name%3D%22notify-communication%22%0Alabels.k8s-pod%2Fapp%3D%22custbill-retrieval-dv%22%0Aseverity%3D%22ERROR%22?project=cio-gke-private-yul-001-9ed5d0"

enabled_custbill_retrieval_error = "true"

enabled_custbill_retrieval_container_restart = "true"

enabled_wnp_processor_error = "false"

roaming_sms_processor_log_url = "https://console.cloud.google.com/logs/query;query=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-9ed5d0%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-np-001%22%0Aresource.labels.namespace_name%3D%22notify-communication%22%0Alabels.k8s-pod%2Fapp%3D%22roaming-sms-processor-dv%22%0Aseverity%3D%22ERROR%22?project=cio-gke-private-yul-001-9ed5d0"

ecp_campaign_project_id = "cio-ecp-campaign-np-62ed36"

gke_console_url = "https://console.cloud.google.com/kubernetes/workload?project=cio-gke-private-yul-001-9ed5d0"

enable_alert = "false"

usage_runbook_url = "https://sites.google.com/telus.com/ecp-gcp-development-guide/monitoring/usage"

message_publisher_service_url                   = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-np-001/notify-communication/message-publisher-svc-dv/overview?project=cio-gke-private-yul-001-9ed5d0"
usage_distribution_subscriber_service_url       = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-np-001/notify-communication/usage-distribution-subscriber-svc-dv/overview?project=cio-gke-private-yul-001-9ed5d0"
usage_policy_subscriber_service_url             = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-np-001/notify-communication/usage-policy-subscriber-svc-dv/overview?project=cio-gke-private-yul-001-9ed5d0"
usage_policy_bc_subscriber_service_url          = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-np-001/notify-communication/usage-policy-bc-subscriber-svc-dv/overview?project=cio-gke-private-yul-001-9ed5d0"
gcp_pubsub_topic_data_usage_url                 = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage?project=cio-notification-np-93822f"
gcp_pubsub_topic_data_usage_policy_sub_url      = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.policy.sub?project=cio-notification-np-93822f"
gcp_pubsub_topic_data_usage_delivery_url        = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage.delivery?project=cio-notification-np-93822f"
gcp_pubsub_topic_data_usage_delivery_sub_url    = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.delivery.sub?project=cio-notification-np-93822f"
gcp_pubsub_topic_data_usage_bc_delivery_url     = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage.bc.delivery?project=cio-notification-np-93822f"
gcp_pubsub_topic_data_usage_bc_delivery_sub_url = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.bc.delivery.sub?project=cio-notification-np-93822f"
usage_preference_service_url                    = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-np-001/notify-communication/usage-preference-svc-dv/overview?project=cio-gke-private-yul-001-9ed5d0"
usage_customer_info_service_url                 = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-np-001/notify-communication/usage-customer-info-svc-dv/overview?project=cio-gke-private-yul-001-9ed5d0"
ecp_commapiv2_service_url                       = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-np-001/notify-communication/communication-api-sender-svc-dv/overview?project=cio-gke-private-yul-001-9ed5d0"

enable_notify_comm_alert = "false"

# these values must match the notification channel names
ecp_batch_msg_extended_channel_name_list = [
  # "ECP Support Email - dlQualicomTest"
]

ecp_batch_msg_tech_support_channel_name_list = [
  # "ECP Support Email - dlQualicomTest"
]

ecp_batch_msg_job_summary_channel_name_list = [
  # "ECP Support Email - dlQualicomTest"
]

no_file_arrival_threashold = "239"
