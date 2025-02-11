# the environment variable for the project

database_id = "cio-notification-pr-64911f:communication-message-pr"

ecp_project_id = "cio-notification-pr-64911f"

wnp_processor_log_url = "https://console.cloud.google.com/logs/query;query=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-2396bd%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-pr-001%22%0Aresource.labels.namespace_name%3D%22notify-communication%22%0Alabels.k8s-pod%2Fapp%3D%22notify-wnp-processor-pr%22%0Aseverity%3DERROR?project=cio-gke-private-yul-001-2396bd"

enabled_wnp_processor_error = "true"

roaming_sms_processor_log_url = "https://console.cloud.google.com/logs/viewer?interval=NO_LIMIT&orgonly=true&project=cio-gke-private-yul-001-9ed5d0&supportedpurview=organizationId&minLogLevel=0&expandAll=false&timestamp=2020-09-23T00:20:33.194000000Z&customFacets=&limitCustomFacetWidth=true&scrollTimestamp=2020-09-22T18:14:06.643063088Z&advancedFilter=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-9ed5d0%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-np-001%22%0Aresource.labels.namespace_name%3D%22notify-communication%22%0Alabels.k8s-pod%2Fapp%3D%22roaming-sms-processor-dv%22%0Aseverity%3D%22ERROR%22"

ecp_campaign_project_id = "cio-ecp-campaign-pr-219deb"

gke_console_url = "https://console.cloud.google.com/kubernetes/workload?project=cio-gke-private-yul-001-2396bd"

enable_alert = "true"

usage_runbook_url = "https://sites.google.com/telus.com/ecp-gcp-development-guide/monitoring/usage"

message_publisher_service_url                   = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/message-publisher-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
usage_distribution_subscriber_service_url       = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-distribution-subscriber-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
usage_policy_subscriber_service_url             = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-policy-subscriber-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
usage_policy_bc_subscriber_service_url          = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-policy-bc-subscriber-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
gcp_pubsub_topic_data_usage_url                 = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage?project=cio-notification-pr-64911f"
gcp_pubsub_topic_data_usage_policy_sub_url      = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.policy.sub?project=cio-notification-pr-64911f"
gcp_pubsub_topic_data_usage_delivery_url        = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage.delivery?project=cio-notification-pr-64911f"
gcp_pubsub_topic_data_usage_delivery_sub_url    = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.delivery.sub?project=cio-notification-pr-64911f"
gcp_pubsub_topic_data_usage_bc_delivery_url     = "https://console.cloud.google.com/cloudpubsub/topic/detail/data.usage.bc.delivery?project=cio-notification-pr-64911f"
gcp_pubsub_topic_data_usage_bc_delivery_sub_url = "https://console.cloud.google.com/cloudpubsub/subscription/detail/data.usage.bc.delivery.sub?project=cio-notification-pr-64911f"
usage_preference_service_url                    = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-preference-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
usage_customer_info_service_url                 = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/usage-customer-info-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"
ecp_commapiv2_service_url                       = "https://console.cloud.google.com/kubernetes/service/northamerica-northeast1/private-yul-pr-001/notify-communication/communication-api-sender-svc-pr/overview?project=cio-gke-private-yul-001-2396bd"

enable_notify_comm_alert = "true"

enabled_custbill_retrieval_error = "true"

enabled_custbill_retrieval_container_restart = "true"

custbill_retrieval_log_url = ""

# these values must match the notification channel names
ecp_batch_msg_extended_channel_name_list = [
  "ECP Extended Email - dlAmdocsTorontoJedis"
]

ecp_batch_msg_tech_support_channel_name_list = [
  "ECP Support Email - DL"
]

ecp_batch_msg_job_summary_channel_name_list = [
  "ECP Xsell Email"
]

no_file_arrival_threashold = "17"
