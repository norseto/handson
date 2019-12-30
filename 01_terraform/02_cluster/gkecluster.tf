resource "google_container_cluster" "this" {
  name     = "hands-on"
  location = "asia-east1-a"

  network    = "${data.google_compute_network.this.self_link}"
  subnetwork = "${data.google_compute_subnetwork.this.self_link}"

  remove_default_node_pool = true
  initial_node_count       = 1

  network_policy {
    enabled = true
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }

  master_authorized_networks_config {
    cidr_blocks {
      display_name = "Home"
      cidr_block   = "[your_IP_address]/32"
    }
  }
}

resource "google_container_node_pool" "this" {
  name       = "primary"
  cluster    = google_container_cluster.this.name
  node_count = 2

  node_config {
    preemptible     = true
    machine_type    = "g1-small"
    image_type      = "cos_containerd"
    service_account = "${data.google_service_account.agent.email}"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
