locals {
  roles_name = [
    "roles/storage.admin"
  ]
}

resource "google_container_cluster" "primary" {
  depends_on         = [google_compute_managed_ssl_certificate.default, google_service_account.cluster_node_pool_sa]
  provider           = google-beta
  name               = "primary"
  project            = var.service_google_project
  location           = var.service_zone
  initial_node_count = 2
  remove_default_node_pool = true
  ip_allocation_policy {}
  node_config {
    machine_type = "e2-standard-2"
  }
  addons_config {
    istio_config {
      disabled = "false"
      #      auth     = "AUTH_MUTUAL_TLS"
    }
  }
  workload_identity_config {
    identity_namespace = "${var.service_google_project}.svc.id.goog"
  }
}

resource "google_service_account" "cluster_node_pool_sa" {
  account_id   = "gke-cluster-node-pool-sa"
  display_name = "GKE SA for NodePool"
}

resource "google_project_iam_member" "cluster-iam-member" {
  depends_on = [google_service_account.cluster_node_pool_sa]
  for_each   = toset(local.roles_name)
  project    = var.project_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.cluster_node_pool_sa.email}"
}

resource "google_container_node_pool" "cluster_node_pool" {
  name       = "cluster-node-pool"
  location   = var.project_zone
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    machine_type = "e2-standard-2"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.cluster_node_pool_sa.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
