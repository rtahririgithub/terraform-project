# the environment variable for the project

privacy_database_id = "cio-notification-pr-64911f:privacy-tmf644-pr"

privacy_project_id = "cio-notification-pr-64911f"

privacyprofile_log_url = "https://console.cloud.google.com/logs/query;query=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-2396bd%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-pr-001%22%0Aresource.labels.namespace_name%3D%22notify-privacy%22%0Alabels.k8s-pod%2Fapp%3D%22notify-privacy-profile-pr%22%0Aseverity%3DERROR?project=cio-gke-private-yul-001-2396bd"

notify_privacy_log_url = "https://console.cloud.google.com/logs/query;query=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22cio-gke-private-yul-001-2396bd%22%0Aresource.labels.location%3D%22northamerica-northeast1%22%0Aresource.labels.cluster_name%3D%22private-yul-pr-001%22%0Aresource.labels.namespace_name%3D%22notify-privacy%22%0Aseverity%3DERROR;?project=cio-gke-private-yul-001-2396bd"

gke_console_url = "https://console.cloud.google.com/kubernetes/workload?project=cio-gke-private-yul-001-2396bd"

gke_public_console_url = "https://console.cloud.google.com/kubernetes/deployment/northamerica-northeast1/public-yul-pr-002/notify-privacy/cmp-unsubscribe-pr/overview?project=cio-gke-public-yul-002-8ddad3"

container_env = "pr"

enable_gke_uptime = "true"

enable_gke_public_uptime = "true"

privacy_enable_alert = "true"
