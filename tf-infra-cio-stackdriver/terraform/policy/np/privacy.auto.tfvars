# the environment variable for the project

privacy_database_id = "cio-notification-np-93822f:privacy-tmf644-np"

privacy_project_id = "cio-notification-np-93822f"

privacyprofile_log_url = "https://console.cloud.google.com/logs/query;query=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-9ed5d0%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-np-001%22%0Aresource.labels.namespace_name%3D%22notify-privacy%22%0Alabels.k8s-pod%2Fapp%3D%22notify-privacy-profile-dv%22%0Aseverity%3DERROR?project=cio-gke-private-yul-001-9ed5d"

notify_privacy_log_url = "https://console.cloud.google.com/logs/query;query=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-9ed5d0%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-np-001%22%0Aresource.labels.namespace_name%3D%22notify-privacy%22;?project=cio-gke-private-yul-001-9ed5d0"

gke_console_url = "https://console.cloud.google.com/kubernetes/workload?project=cio-gke-private-yul-001-9ed5d0"

gke_public_console_url = "https://console.cloud.google.com/kubernetes/deployment/northamerica-northeast1/public-yul-np-002/notify-privacy/cmp-unsubscribe-dv/overview?project=cio-gke-public-yul-002-329431"

container_env = "dv"

enable_gke_uptime = "false"

enable_gke_public_uptime = "false"

privacy_enable_alert = "false"
