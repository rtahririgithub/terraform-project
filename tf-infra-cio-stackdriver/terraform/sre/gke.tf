locals {
  gke_private_yul_001 = var.env == "np" ? "//container.googleapis.com/projects/cio-gke-private-yul-001-9ed5d0/locations/northamerica-northeast1/clusters/private-yul-np-001/k8s" : ""
  gke_public_yul_002  = var.env == "np" ? "//container.googleapis.com/projects/cio-gke-public-yul-002-329431/locations/northamerica-northeast1/clusters/public-yul-np-002/k8s" : ""
}
